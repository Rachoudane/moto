import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';
import '../models/habit.dart';
import '../services/badge_service.dart';
import '../services/notification_service.dart';
import '../services/storage_service.dart';
import '../services/subscription_service.dart';
import '../utils/text_utils.dart';
import '../widgets/frequency_picker.dart';
import '../widgets/habit_calendar.dart';
import '../widgets/habit_progress.dart';
import 'pro_screen.dart';

class HabitDetailScreen extends StatefulWidget {
  final Habit habit;
  final VoidCallback onUpdate;
  final VoidCallback onDelete;

  const HabitDetailScreen({
    super.key,
    required this.habit,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<HabitDetailScreen> createState() => _HabitDetailScreenState();
}

class _HabitDetailScreenState extends State<HabitDetailScreen> {
  final StorageService _storageService = StorageService();
  bool _isPro = false;

  @override
  void initState() {
    super.initState();
    _loadProStatus();
  }

  Future<void> _loadProStatus() async {
    final isPro = await SubscriptionService.isPro();
    if (mounted) {
      setState(() => _isPro = isPro);
    }
  }

  String _getModeName(AppLocalizations l10n, PenaltyMode mode) {
    switch (mode) {
      case PenaltyMode.zen:
        return '🌱 ${l10n.zen}';
      case PenaltyMode.standard:
        return '⚡ ${l10n.standard}';
      case PenaltyMode.hardcore:
        return '🔥 ${l10n.hardcore}';
    }
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

  String _getDayName(AppLocalizations l10n, int day) {
    switch (day) {
      case 0:
        return l10n.monday;
      case 1:
        return l10n.tuesday;
      case 2:
        return l10n.wednesday;
      case 3:
        return l10n.thursday;
      case 4:
        return l10n.friday;
      case 5:
        return l10n.saturday;
      case 6:
        return l10n.sunday;
      default:
        return '';
    }
  }

  (int level, int progress, int totalForNext) _getStats() {
    int level = 1;
    int total = 0;
    while (total + level * level <= widget.habit.streak) {
      total += level * level;
      level++;
    }
    int progress = widget.habit.streak - total;
    int totalForNext = level * level;
    return (level, progress, totalForNext);
  }

  int _getTotalSquaresCompleted() {
    int level = 1;
    int total = 0;
    while (total + level * level <= widget.habit.streak) {
      total += level * level;
      level++;
    }
    return level - 1;
  }

  /// Applies a new day status to [date] and recalculates the streak from
  /// scratch by replaying the full history. Used both for correcting today's
  /// status and for editing arbitrary past dates (Pro / within free window).
  Future<void> _editDayStatus(
    DateTime date,
    DayStatus newStatus,
    StateSetter setModalState,
  ) async {
    final habit = widget.habit;

    setState(() {
      if (newStatus == DayStatus.pending) {
        habit.history.remove(_dateKey(date));
      } else {
        habit.setStatusForDate(date, newStatus);
      }
      habit.recalculateStreak();
    });

    final allHabits = await _storageService.loadHabits();
    final habitIndex = allHabits.indexWhere((h) => h.id == habit.id);
    if (habitIndex != -1) {
      allHabits[habitIndex] = habit;
      await _storageService.saveHabits(allHabits);
      await BadgeService.checkAndUnlock(allHabits);
    }

    setModalState(() {});
    widget.onUpdate();
  }

  String _dateKey(DateTime date) =>
      "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

  void _handleDayTap(DateTime date) {
    final today = DateTime.now();
    final todayNorm = DateTime(today.year, today.month, today.day);
    final daysAgo = todayNorm.difference(date).inDays;

    if (!_isPro && daysAgo > SubscriptionService.freeHistoryDays) {
      final l10n = AppLocalizations.of(context)!;
      _showUpgradeDialog(
        title: l10n.editHistoryProTitle,
        description: l10n.editHistoryProDescription,
      );
      return;
    }

    _showEditDaySheet(date);
  }

  void _showEditDaySheet(DateTime date) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context).extension<MotoTheme>()!;
    final locale = Localizations.localeOf(context).toString();

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final currentStatus = widget.habit.getStatusForDate(date);
            return Padding(
              padding: EdgeInsets.fromLTRB(
                24,
                24,
                24,
                32 + MediaQuery.of(context).viewPadding.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    capitalizeFirst(DateFormat.yMMMMEEEEd(locale).format(date)),
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: theme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildDayStatusOption(
                    theme,
                    icon: Icons.check,
                    label: l10n.markAsValidated,
                    color: theme.accentGreen,
                    isSelected: currentStatus == DayStatus.validated,
                    onTap: () => _editDayStatus(
                      date,
                      DayStatus.validated,
                      setModalState,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildDayStatusOption(
                    theme,
                    icon: Icons.close,
                    label: l10n.markAsSkipped,
                    color: theme.danger,
                    isSelected: currentStatus == DayStatus.skipped,
                    onTap: () => _editDayStatus(
                      date,
                      DayStatus.skipped,
                      setModalState,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildDayStatusOption(
                    theme,
                    icon: Icons.remove_circle_outline,
                    label: l10n.clearDay,
                    color: theme.textSecondary,
                    isSelected: currentStatus == DayStatus.pending,
                    onTap: () => _editDayStatus(
                      date,
                      DayStatus.pending,
                      setModalState,
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

  Widget _buildDayStatusOption(
    MotoTheme theme, {
    required IconData icon,
    required String label,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.15) : theme.bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color.withValues(alpha: 0.4) : theme.borderColor,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.inter(
                color: theme.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation() {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context).extension<MotoTheme>()!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          l10n.deleteHabit,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: theme.textPrimary,
          ),
        ),
        content: Text(
          l10n.deleteHabitConfirm(widget.habit.streak),
          style: GoogleFonts.inter(
            fontSize: 14,
            color: theme.textSecondary,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              l10n.cancel,
              style: GoogleFonts.inter(
                color: theme.accentGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              widget.onDelete();
            },
            child: Text(
              l10n.delete,
              style: GoogleFonts.inter(
                color: theme.danger,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog() {
    String name = widget.habit.name;
    bool isQuitting = widget.habit.isQuitting;
    PenaltyMode penaltyMode = widget.habit.penaltyMode;
    Set<int> scheduledWeekdays = {...widget.habit.scheduledWeekdays};
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
                    l10n.editHabit,
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: modalTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    initialValue: name,
                    textCapitalization: TextCapitalization.sentences,
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
                      Expanded(
                        child: _buildModeButton(
                          setModalState,
                          modalTheme,
                          mode: PenaltyMode.zen,
                          currentMode: penaltyMode,
                          emoji: '🌱',
                          label: l10n.zen,
                          onTap: () => setModalState(
                            () => penaltyMode = PenaltyMode.zen,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildModeButton(
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
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildModeButton(
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
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getModeDescription(l10n, penaltyMode),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      height: 1.4,
                      color: modalTheme.textSecondary.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FrequencyPicker(
                    selectedWeekdays: scheduledWeekdays,
                    onChanged: (updated) =>
                        setModalState(() => scheduledWeekdays = updated),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: GestureDetector(
                      onTap: () async {
                        if (name.trim().isNotEmpty) {
                          // Update the habit object
                          widget.habit.name = capitalizeFirst(name.trim());
                          widget.habit.isQuitting = isQuitting;
                          widget.habit.penaltyMode = penaltyMode;
                          widget.habit.scheduledWeekdays = scheduledWeekdays;

                          // Save to storage
                          final allHabits = await _storageService.loadHabits();
                          final habitIndex = allHabits.indexWhere(
                            (h) => h.id == widget.habit.id,
                          );
                          if (habitIndex != -1) {
                            allHabits[habitIndex] = widget.habit;
                            await _storageService.saveHabits(allHabits);
                          }

                          setState(() {});
                          widget.onUpdate();
                          if (context.mounted) {
                            Navigator.pop(context);
                          }
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
                            l10n.save,
                            style: GoogleFonts.inter(
                              color: modalTheme.bg,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        _showDeleteConfirmation();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: modalTheme.danger.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: modalTheme.danger.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            l10n.delete,
                            style: GoogleFonts.inter(
                              color: modalTheme.danger,
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

  bool _isModeAvailable(PenaltyMode mode) {
    if (_isPro) return true;
    return mode == PenaltyMode.standard;
  }

  void _showUpgradeDialog({String? title, String? description}) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context).extension<MotoTheme>()!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.star, color: Color(0xFFE5C07B)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title ?? l10n.habitLimitReached,
                style: GoogleFonts.inter(
                  color: theme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          description ?? l10n.upgradeToAddMore,
          style: GoogleFonts.inter(color: theme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              l10n.cancel,
              style: GoogleFonts.inter(color: theme.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProScreen()),
              ).then((_) => _loadProStatus());
            },
            child: Text(
              l10n.upgrade,
              style: GoogleFonts.inter(color: theme.accentGreen),
            ),
          ),
        ],
      ),
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
    final isAvailable = _isModeAvailable(mode);

    return GestureDetector(
      onTap: isAvailable
          ? onTap
          : () {
              final l10n = AppLocalizations.of(context)!;
              _showUpgradeDialog(
                title: l10n.penaltyModeProTitle,
                description: l10n.penaltyModeProDescription,
              );
            },
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
        child: Opacity(
          opacity: isAvailable ? 1.0 : 0.5,
          child: Column(
            children: [
              Text(
                isAvailable ? emoji : '🔒',
                style: const TextStyle(fontSize: 18),
              ),
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

  Widget _buildReminderCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context).extension<MotoTheme>()!;
    final habit = widget.habit;
    final locale = Localizations.localeOf(context).languageCode;

    String timeText = l10n.noReminder;
    if (habit.reminderEnabled &&
        habit.reminderHour != null &&
        habit.reminderMinute != null) {
      timeText =
          "${habit.reminderHour!.toString().padLeft(2, '0')}:${habit.reminderMinute!.toString().padLeft(2, '0')}";
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.notifications_outlined,
                    size: 18,
                    color: theme.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.reminder,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: theme.textPrimary,
                    ),
                  ),
                  if (!_isPro) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5C07B).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'PRO',
                        style: GoogleFonts.inter(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFE5C07B),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              Switch(
                value: habit.reminderEnabled,
                onChanged: (value) async {
                  // Pro feature gate
                  if (value && !_isPro) {
                    final l10n = AppLocalizations.of(context)!;
                    _showUpgradeDialog(
                      title: l10n.reminderProTitle,
                      description: l10n.reminderProDescription,
                    );
                    return;
                  }

                  if (value) {
                    final hasPermission =
                        await NotificationService.requestPermission();
                    if (!hasPermission) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.permissionRequired)),
                        );
                      }
                      return;
                    }
                  }

                  // Load all habits, modify this one, and save
                  final allHabits = await _storageService.loadHabits();
                  final habitIndex = allHabits.indexWhere(
                    (h) => h.id == widget.habit.id,
                  );

                  if (habitIndex != -1) {
                    allHabits[habitIndex].reminderEnabled = value;
                    setState(() {
                      habit.reminderEnabled = value;
                    });

                    if (!value) {
                      NotificationService.cancelHabitReminder(widget.habit.id);
                    } else if (allHabits[habitIndex].reminderHour != null &&
                        allHabits[habitIndex].reminderMinute != null) {
                      try {
                        await NotificationService.scheduleHabitReminder(
                          habit: allHabits[habitIndex],
                          hour: allHabits[habitIndex].reminderHour!,
                          minute: allHabits[habitIndex].reminderMinute!,
                          locale: locale,
                        );
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.errorGeneric(e.toString())),
                            ),
                          );
                        }
                      }
                    }

                    await _storageService.saveHabits(allHabits);
                  }
                },
                activeTrackColor: theme.accentGreen,
              ),
            ],
          ),
          if (habit.reminderEnabled) ...[
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () async {
                final now = TimeOfDay.now();
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay(
                    hour: habit.reminderHour ?? now.hour,
                    minute: habit.reminderMinute ?? now.minute,
                  ),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: ColorScheme.dark(
                          primary: theme.accentGreen,
                          surface: theme.cardBg,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (time != null) {
                  // Load all habits, modify this one, and save
                  final allHabits = await _storageService.loadHabits();
                  final habitIndex = allHabits.indexWhere(
                    (h) => h.id == widget.habit.id,
                  );

                  if (habitIndex != -1) {
                    allHabits[habitIndex].reminderHour = time.hour;
                    allHabits[habitIndex].reminderMinute = time.minute;

                    setState(() {
                      habit.reminderHour = time.hour;
                      habit.reminderMinute = time.minute;
                    });

                    try {
                      await NotificationService.scheduleHabitReminder(
                        habit: allHabits[habitIndex],
                        hour: time.hour,
                        minute: time.minute,
                        locale: locale,
                      );
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.errorGeneric(e.toString())),
                          ),
                        );
                      }
                    }

                    await _storageService.saveHabits(allHabits);
                  }
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: theme.emptySquare,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.reminderTime,
                      style: GoogleFonts.inter(color: theme.textSecondary),
                    ),
                    Text(
                      timeText,
                      style: GoogleFonts.inter(
                        color: theme.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final (currentLevel, progress, totalForNext) = _getStats();
    final completedSquares = _getTotalSquaresCompleted();
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context).extension<MotoTheme>()!;

    return Scaffold(
      backgroundColor: theme.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: SizedBox(
          height: kToolbarHeight,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.habit.name,
                style: GoogleFonts.inter(
                  color: theme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit_outlined, color: theme.textSecondary),
            onPressed: _showEditDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.habit.isQuitting)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: theme.danger.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: theme.danger.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  l10n.toQuit,
                  style: GoogleFonts.inter(
                    color: theme.danger,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            const SizedBox(height: 28),
            Center(
              child: Transform.scale(
                scale: 2,
                child: HabitProgress(streak: widget.habit.streak),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              l10n.history,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: theme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            HabitCalendar(
              habit: widget.habit,
              daysToShow: _isPro ? 35 : SubscriptionService.freeHistoryDays,
              onDayTap: _handleDayTap,
            ),
            const SizedBox(height: 32),
            _buildStatCard(
              context,
              title: l10n.penaltyMode,
              value: _getModeName(l10n, widget.habit.penaltyMode),
              subtitle: _getModeDescription(l10n, widget.habit.penaltyMode),
            ),
            const SizedBox(height: 16),
            _buildStatCard(
              context,
              title: l10n.frequency,
              value: widget.habit.isDailyFrequency
                  ? l10n.everyDay
                  : l10n.specificDays,
              subtitle: frequencySummary(
                l10n,
                Localizations.localeOf(context).toString(),
                widget.habit.scheduledWeekdays,
              ),
            ),
            const SizedBox(height: 16),
            _buildReminderCard(context),
            const SizedBox(height: 32),
            Text(
              l10n.statistics,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: theme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildAdvancedStatCard(
                    context,
                    title: l10n.currentStreak,
                    value: "${widget.habit.currentStreak}",
                    subtitle: l10n.days,
                    icon: Icons.local_fire_department_outlined,
                    iconColor: const Color(0xFFE5C07B),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildAdvancedStatCard(
                    context,
                    title: l10n.longestStreak,
                    value: "${widget.habit.longestStreak}",
                    subtitle: l10n.days,
                    icon: Icons.emoji_events_outlined,
                    iconColor: const Color(0xFFE5C07B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildAdvancedStatCard(
                    context,
                    title: l10n.successRate,
                    value: "${widget.habit.successRate.toStringAsFixed(0)}%",
                    subtitle: "${widget.habit.totalValidatedDays} ${l10n.days}",
                    icon: Icons.trending_up_outlined,
                    iconColor: theme.accentGreen,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildAdvancedStatCard(
                    context,
                    title: l10n.bestDay,
                    value: widget.habit.bestDayOfWeek != null
                        ? _getDayName(l10n, widget.habit.bestDayOfWeek!)
                        : "-",
                    subtitle: widget.habit.bestDayOfWeek != null
                        ? ""
                        : l10n.noDataYet,
                    icon: Icons.calendar_today_outlined,
                    iconColor: theme.accentGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildAdvancedStatCard(
                    context,
                    title: l10n.currentProgress,
                    value: '$progress / $totalForNext',
                    subtitle: l10n.squareInProgress(currentLevel),
                    icon: Icons.layers_outlined,
                    iconColor: const Color(0xFFE5C07B),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildAdvancedStatCard(
                    context,
                    title: l10n.totalCells,
                    value: '${widget.habit.streak}',
                    subtitle: l10n.completedSquares(completedSquares),
                    icon: Icons.grid_on_outlined,
                    iconColor: theme.accentGreen,
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).viewPadding.bottom + 16),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required String subtitle,
  }) {
    final theme = Theme.of(context).extension<MotoTheme>()!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.borderColor.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: theme.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: theme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: theme.textSecondary.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
  }) {
    final theme = Theme.of(context).extension<MotoTheme>()!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.borderColor.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: theme.textSecondary,
                  ),
                ),
              ),
              Icon(icon, size: 16, color: iconColor),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: theme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: theme.textSecondary.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
