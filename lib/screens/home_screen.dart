import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';
import '../models/habit.dart';
import '../services/notification_service.dart';
import '../services/storage_service.dart';
import '../widgets/habit_card.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  final Function(Locale)? onLanguageChanged;
  final Function(bool)? onThemeChanged;
  final bool isDarkMode;

  const HomeScreen({
    super.key,
    this.onLanguageChanged,
    this.onThemeChanged,
    this.isDarkMode = true,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StorageService _storageService = StorageService();
  List<Habit> _habits = [];
  bool _isLoading = true;

  String _formattedDate(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    return DateFormat.yMMMMEEEEd(locale).format(DateTime.now());
  }

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    final habits = await _storageService.loadHabits();
    setState(() {
      _habits = habits;
      _isLoading = false;
    });
    _checkMissedDays();
    // Reschedule reminders after frame is built (to get locale)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final locale = Localizations.localeOf(context).languageCode;
        NotificationService.rescheduleAllReminders(_habits, locale);
      }
    });
  }

  void _checkMissedDays() {
    bool hasChanges = false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    for (final habit in _habits) {
      if (habit.lastValidatedDate != null && habit.daysMissed > 0) {
        // Cas normal: habitude déjà validée au moins une fois
        final lastDate = DateTime(
          habit.lastValidatedDate!.year,
          habit.lastValidatedDate!.month,
          habit.lastValidatedDate!.day,
        );
        for (int i = 1; i <= habit.daysMissed; i++) {
          final missedDate = lastDate.add(Duration(days: i));
          habit.setStatusForDate(missedDate, DayStatus.skipped);
          _applyPenalty(habit);
        }
        habit.lastValidatedDate = DateTime.now();
        hasChanges = true;
      } else if (habit.lastValidatedDate == null) {
        // Nouvelle habitude jamais validée: vérifier les jours depuis la création
        final createdDate = DateTime(
          habit.createdAt.year,
          habit.createdAt.month,
          habit.createdAt.day,
        );
        final daysSinceCreation = today.difference(createdDate).inDays;

        if (daysSinceCreation > 0) {
          // Marquer les jours passés (sauf aujourd'hui) comme manqués
          for (int i = 0; i < daysSinceCreation; i++) {
            final missedDate = createdDate.add(Duration(days: i));
            // Ne marquer que si pas déjà dans l'historique
            if (habit.getStatusForDate(missedDate) == DayStatus.pending) {
              habit.setStatusForDate(missedDate, DayStatus.skipped);
              _applyPenalty(habit);
            }
          }
          hasChanges = true;
        }
      }
    }

    if (hasChanges) {
      setState(() {});
      _saveHabits();
    }
  }

  void _applyPenalty(Habit habit) {
    switch (habit.penaltyMode) {
      case PenaltyMode.zen:
        if (habit.streak > 0) habit.streak--;
        break;
      case PenaltyMode.standard:
        int level = 1;
        int total = 0;
        while (total + level * level <= habit.streak) {
          total += level * level;
          level++;
        }
        if (habit.streak > total) {
          habit.streak = total;
        }
        break;
      case PenaltyMode.hardcore:
        habit.streak = 0;
        break;
    }
  }

  Future<void> _saveHabits() async {
    await _storageService.saveHabits(_habits);
  }

  void _incrementStreak(String id) {
    final habit = _habits.firstWhere((h) => h.id == id);
    if (!habit.isValidatedToday) {
      HapticFeedback.mediumImpact();
      setState(() {
        habit.setStreakBeforeAction(DateTime.now(), habit.streak);
        habit.streak++;
        habit.lastValidatedDate = DateTime.now();
        habit.setStatusForDate(DateTime.now(), DayStatus.validated);
      });
      _saveHabits();
      // Cancel today's reminder and reschedule for tomorrow
      if (habit.reminderEnabled) {
        NotificationService.cancelHabitReminder(habit.id);
        final locale = Localizations.localeOf(context).languageCode;
        NotificationService.scheduleHabitReminder(
          habit: habit,
          hour: habit.reminderHour!,
          minute: habit.reminderMinute!,
          locale: locale,
        );
      }
    }
  }

  void _decrementStreak(String id) {
    final habit = _habits.firstWhere((h) => h.id == id);
    if (!habit.isValidatedToday) {
      HapticFeedback.lightImpact();
      setState(() {
        habit.setStreakBeforeAction(DateTime.now(), habit.streak);
        _applyPenalty(habit);
        habit.lastValidatedDate = DateTime.now();
        habit.setStatusForDate(DateTime.now(), DayStatus.skipped);
      });
      _saveHabits();
      // Cancel today's reminder and reschedule for tomorrow
      if (habit.reminderEnabled) {
        NotificationService.cancelHabitReminder(habit.id);
        final locale = Localizations.localeOf(context).languageCode;
        NotificationService.scheduleHabitReminder(
          habit: habit,
          hour: habit.reminderHour!,
          minute: habit.reminderMinute!,
          locale: locale,
        );
      }
    }
  }

  void _addHabit(String name, bool isQuitting, PenaltyMode penaltyMode) {
    HapticFeedback.lightImpact();
    setState(() {
      _habits.add(
        Habit(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: name,
          isQuitting: isQuitting,
          penaltyMode: penaltyMode,
        ),
      );
    });
    _saveHabits();
  }

  void _deleteHabit(String id) {
    HapticFeedback.heavyImpact();
    NotificationService.cancelHabitReminder(id);
    setState(() {
      _habits.removeWhere((h) => h.id == id);
    });
    _saveHabits();
  }

  void _updateHabit() {
    // Reload habits from storage to ensure latest changes
    _loadHabits();
  }

  void _showAddHabitDialog() {
    String name = '';
    bool isQuitting = false;
    PenaltyMode penaltyMode = PenaltyMode.standard;
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context).extension<MotoTheme>()!;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final modalTheme = Theme.of(context).extension<MotoTheme>()!;
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                bottom:
                    MediaQuery.of(context).viewInsets.bottom +
                    MediaQuery.of(context).viewPadding.bottom +
                    24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.newHabit,
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: modalTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    autofocus: true,
                    style: GoogleFonts.inter(color: modalTheme.textPrimary),
                    decoration: InputDecoration(
                      hintText: l10n.habitName,
                      hintStyle: GoogleFonts.inter(
                        color: modalTheme.textSecondary,
                      ),
                      filled: true,
                      fillColor: modalTheme.bg,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) => name = value,
                  ),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setModalState(() => isQuitting = false),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: !isQuitting
                                  ? modalTheme.accentGreen.withValues(
                                      alpha: 0.2,
                                    )
                                  : modalTheme.bg,
                              borderRadius: BorderRadius.circular(10),
                              border: !isQuitting
                                  ? Border.all(
                                      color: modalTheme.accentGreen.withValues(
                                        alpha: 0.4,
                                      ),
                                    )
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                l10n.toDo,
                                style: GoogleFonts.inter(
                                  color: !isQuitting
                                      ? modalTheme.accentGreen
                                      : modalTheme.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setModalState(() => isQuitting = true),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: isQuitting
                                  ? modalTheme.danger.withValues(alpha: 0.2)
                                  : modalTheme.bg,
                              borderRadius: BorderRadius.circular(10),
                              border: isQuitting
                                  ? Border.all(
                                      color: modalTheme.danger.withValues(
                                        alpha: 0.4,
                                      ),
                                    )
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                l10n.toQuit,
                                style: GoogleFonts.inter(
                                  color: isQuitting
                                      ? modalTheme.danger
                                      : modalTheme.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  Text(
                    l10n.penaltyMode,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: modalTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _buildModeButton(
                        setModalState,
                        modalTheme,
                        mode: PenaltyMode.zen,
                        currentMode: penaltyMode,
                        emoji: '🌱',
                        label: l10n.zen,
                        onTap: () =>
                            setModalState(() => penaltyMode = PenaltyMode.zen),
                      ),
                      const SizedBox(width: 8),
                      _buildModeButton(
                        setModalState,
                        modalTheme,
                        mode: PenaltyMode.standard,
                        currentMode: penaltyMode,
                        emoji: '⚡',
                        label: l10n.standard,
                        onTap: () => setModalState(
                          () => penaltyMode = PenaltyMode.standard,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildModeButton(
                        setModalState,
                        modalTheme,
                        mode: PenaltyMode.hardcore,
                        currentMode: penaltyMode,
                        emoji: '🔥',
                        label: l10n.hardcore,
                        onTap: () => setModalState(
                          () => penaltyMode = PenaltyMode.hardcore,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getModeDescription(l10n, penaltyMode),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: modalTheme.textSecondary.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: GestureDetector(
                      onTap: () {
                        if (name.trim().isNotEmpty) {
                          _addHabit(name.trim(), isQuitting, penaltyMode);
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: modalTheme.accentGreen,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            l10n.create,
                            style: GoogleFonts.inter(
                              color: modalTheme.bg,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildModeButton(
    StateSetter setModalState,
    MotoTheme theme, {
    required PenaltyMode mode,
    required PenaltyMode currentMode,
    required String emoji,
    required String label,
    required VoidCallback onTap,
  }) {
    final isSelected = mode == currentMode;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.textPrimary.withValues(alpha: 0.1)
                : theme.bg,
            borderRadius: BorderRadius.circular(10),
            border: isSelected
                ? Border.all(color: theme.textPrimary.withValues(alpha: 0.2))
                : null,
          ),
          child: Column(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 4),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                  color: isSelected ? theme.textPrimary : theme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getModeDescription(AppLocalizations l10n, PenaltyMode mode) {
    switch (mode) {
      case PenaltyMode.zen:
        return l10n.zenDescription;
      case PenaltyMode.standard:
        return l10n.standardDescription;
      case PenaltyMode.hardcore:
        return l10n.hardcoreDescription;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<MotoTheme>()!;

    return Scaffold(
      floatingActionButton: FloatingActionButton.small(
        onPressed: _showAddHabitDialog,
        backgroundColor: theme.accentGreen,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Icon(Icons.add, color: theme.bg, size: 22),
      ),
      body: SafeArea(
        child: _isLoading
            ? Center(child: CircularProgressIndicator(color: theme.accentGreen))
            : Builder(
                builder: (context) {
                  final l10n = AppLocalizations.of(context)!;
                  return Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.ideographic,
                                    children: [
                                      Text(
                                        l10n.appSubtitle,
                                        style: TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.w300,
                                          color: theme.textPrimary.withValues(
                                            alpha: 0.2,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        l10n.appTitle,
                                        style: GoogleFonts.inter(
                                          fontSize: 28,
                                          fontWeight: FontWeight.w700,
                                          color: theme.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _formattedDate(context),
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: theme.textSecondary,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SettingsScreen(
                                        onLanguageChanged:
                                            widget.onLanguageChanged ?? (_) {},
                                        onThemeChanged:
                                            widget.onThemeChanged ?? (_) {},
                                        isDarkMode: widget.isDarkMode,
                                      ),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                    12,
                                  ), // 👈 zone tactile
                                  child: Icon(
                                    Icons.settings_outlined,
                                    color: theme.textSecondary.withValues(
                                      alpha: 0.5,
                                    ),
                                    size: 22,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 36),

                        Expanded(
                          child: _habits.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.grid_view_rounded,
                                        size: 48,
                                        color: theme.textSecondary.withValues(
                                          alpha: 0.25,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Text(
                                        l10n.noHabits,
                                        style: GoogleFonts.inter(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                          color: theme.textSecondary,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        l10n.noHabitsSubtitle,
                                        style: GoogleFonts.inter(
                                          fontSize: 13,
                                          color: theme.textSecondary.withValues(
                                            alpha: 0.6,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.separated(
                                  padding: EdgeInsets.only(
                                    bottom:
                                        MediaQuery.of(
                                          context,
                                        ).viewPadding.bottom +
                                        80,
                                  ),
                                  itemCount: _habits.length,
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(height: 14),
                                  itemBuilder: (context, index) {
                                    final habit = _habits[index];
                                    return HabitCard(
                                      habit: habit,
                                      onIncrement: () =>
                                          _incrementStreak(habit.id),
                                      onDecrement: () =>
                                          _decrementStreak(habit.id),
                                      onDelete: () => _deleteHabit(habit.id),
                                      onUpdate: _updateHabit,
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
