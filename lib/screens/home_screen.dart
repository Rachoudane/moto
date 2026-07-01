import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';
import '../models/app_badge.dart';
import '../models/habit.dart';
import '../services/badge_service.dart';
import '../services/motivation_service.dart';
import '../services/notification_service.dart';
import '../services/share_service.dart';
import '../services/storage_service.dart';
import '../services/subscription_service.dart';
import '../widgets/habit_card.dart';
import 'badges_screen.dart';
import 'pro_screen.dart';
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
  bool _isPro = false;
  int _badgeCount = 0;
  bool _showPromoCard = false;

  String _formattedDate(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    return DateFormat.yMMMMEEEEd(locale).format(DateTime.now());
  }

  int _completedSquaresFor(int streak) {
    int level = 1;
    int total = 0;
    while (total + level * level <= streak) {
      total += level * level;
      level++;
    }
    return level - 1;
  }

  @override
  void initState() {
    super.initState();
    _loadHabits();
    _loadProStatus();
    _loadBadgeCount();
    _checkDowngradeNotice();
    _loadPromoCardVisibility();
  }

  Future<void> _loadBadgeCount() async {
    final unlocked = await BadgeService.getUnlocked();
    if (mounted) setState(() => _badgeCount = unlocked.length);
  }

  Future<void> _loadPromoCardVisibility() async {
    final show = await SubscriptionService.shouldShowPromoCard();
    if (mounted) setState(() => _showPromoCard = show);
  }

  Future<void> _checkDowngradeNotice() async {
    final shouldShow = await SubscriptionService.shouldShowDowngradeNotice();
    if (!shouldShow || !mounted) return;
    // Defer until after first frame so context/theme/l10n are ready.
    WidgetsBinding.instance.addPostFrameCallback((_) => _showDowngradeNotice());
  }

  void _showDowngradeNotice() {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context).extension<MotoTheme>()!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.info_outline, color: theme.accentGreen),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                l10n.proDowngradeTitle,
                style: GoogleFonts.inter(
                  color: theme.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          l10n.proDowngradeDescription,
          style: GoogleFonts.inter(color: theme.textSecondary, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () {
              SubscriptionService.dismissDowngradeNotice();
              Navigator.pop(context);
            },
            child: Text(
              l10n.cancel,
              style: GoogleFonts.inter(color: theme.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              SubscriptionService.dismissDowngradeNotice();
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProScreen()),
              ).then((_) {
                _loadProStatus();
                _loadPromoCardVisibility();
              });
            },
            child: Text(
              l10n.upgrade,
              style: GoogleFonts.inter(
                color: theme.accentGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _loadProStatus() async {
    final isPro = await SubscriptionService.isPro();
    if (mounted) {
      setState(() {
        _isPro = isPro;
      });
    }
  }

  Future<void> _loadHabits() async {
    final habits = await _storageService.loadHabits();
    setState(() {
      _habits = habits;
      _isLoading = false;
    });
    _checkMissedDays();
    // Reschedule reminders after frame is built (to get locale)
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final locale = Localizations.localeOf(context).languageCode;
      NotificationService.rescheduleAllReminders(_habits, locale);
      if (await NotificationService.isDailyQuoteEnabled()) {
        await NotificationService.requestPermission();
        NotificationService.scheduleDailyQuoteNotification(locale);
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
        final missedDays = habit.daysMissed;
        for (int i = 1; i <= missedDays; i++) {
          final missedDate = lastDate.add(Duration(days: i));
          habit.setStatusForDate(missedDate, DayStatus.skipped);
          _applyPenalty(habit);
        }
        // Set to the last missed day (yesterday), not today, so user can still vote today
        habit.lastValidatedDate = lastDate.add(Duration(days: missedDays));
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
    habit.streak = Habit.applyPenalty(habit.penaltyMode, habit.streak);
  }

  Future<void> _saveHabits() async {
    await _storageService.saveHabits(_habits);
  }

  void _incrementStreak(String id) {
    final habit = _habits.firstWhere((h) => h.id == id);
    if (!habit.isValidatedToday) {
      HapticFeedback.mediumImpact();
      final beforeCompletedSquares = _completedSquaresFor(habit.streak);
      setState(() {
        habit.streak++;
        habit.lastValidatedDate = DateTime.now();
        habit.setStatusForDate(DateTime.now(), DayStatus.validated);
      });
      _saveHabits();
      _afterValidationEffects(habit, beforeCompletedSquares);
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

  /// Runs badge checks and shows celebratory feedback (square completion,
  /// streak milestone, badge unlocks) after a successful validation.
  Future<void> _afterValidationEffects(
    Habit habit,
    int beforeCompletedSquares,
  ) async {
    final afterCompletedSquares = _completedSquaresFor(habit.streak);
    final newBadges = await BadgeService.checkAndUnlock(_habits);
    if (!mounted) return;

    final l10n = AppLocalizations.of(context)!;
    if (afterCompletedSquares > beforeCompletedSquares) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.squareCompletedCelebration(afterCompletedSquares)),
          action: SnackBarAction(
            label: l10n.shareApp,
            onPressed: () =>
                ShareService.shareSquareCompletion(habit, afterCompletedSquares, l10n),
          ),
          duration: const Duration(seconds: 5),
        ),
      );
    } else if ([7, 30, 100, 365].contains(habit.currentStreak)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.streakMilestoneCelebration(habit.currentStreak)),
          action: SnackBarAction(
            label: l10n.shareApp,
            onPressed: () => ShareService.shareProgress(habit, l10n),
          ),
          duration: const Duration(seconds: 5),
        ),
      );
    }

    for (final badgeType in newBadges) {
      if (!mounted) return;
      await _showBadgeCelebration(badgeType);
    }

    if (newBadges.isNotEmpty) {
      _loadBadgeCount();
    }
  }

  Future<void> _showBadgeCelebration(BadgeType type) async {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context).extension<MotoTheme>()!;
    const amber = Color(0xFFE5C07B);
    final unlocked = (await BadgeService.getUnlocked())
        .firstWhere((b) => b.type == type);

    if (!mounted) return;

    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'badge',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (context, anim1, anim2) {
        return Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: theme.cardBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: amber.withValues(alpha: 0.4)),
              boxShadow: [
                BoxShadow(
                  color: amber.withValues(alpha: 0.3),
                  blurRadius: 30,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(badgeIcons[type], color: amber, size: 48)
                    .animate()
                    .scale(
                      duration: 500.ms,
                      curve: Curves.elasticOut,
                      begin: const Offset(0.3, 0.3),
                      end: const Offset(1, 1),
                    ),
                const SizedBox(height: 16),
                Text(
                  l10n.badgeUnlockedTitle,
                  style: GoogleFonts.inter(
                    color: amber,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  ShareService.badgeName(type, l10n),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: theme.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  ShareService.badgeDescription(type, l10n),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: theme.textSecondary,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ShareService.shareBadge(unlocked, l10n);
                      },
                      child: Text(
                        l10n.shareApp,
                        style: GoogleFonts.inter(color: theme.accentGreen),
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        l10n.cancel,
                        style: GoogleFonts.inter(color: theme.textSecondary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ).animate().fadeIn(duration: 250.ms).scale(
                begin: const Offset(0.9, 0.9),
                end: const Offset(1, 1),
                duration: 250.ms,
              ),
        );
      },
    );
  }

  void _decrementStreak(String id) {
    final habit = _habits.firstWhere((h) => h.id == id);
    if (!habit.isValidatedToday) {
      HapticFeedback.lightImpact();
      setState(() {
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
    _loadProStatus();
    _loadBadgeCount();
  }

  void _reorderHabits(int oldIndex, int newIndex) {
    HapticFeedback.selectionClick();
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final habit = _habits.removeAt(oldIndex);
      _habits.insert(newIndex, habit);
    });
    _saveHabits();
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

  void _showAddHabitDialog() {
    // Check free limit
    if (!_isPro && _habits.length >= SubscriptionService.freeHabitLimit) {
      _showUpgradeDialog();
      return;
    }

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

  bool _isModeAvailable(PenaltyMode mode) {
    if (_isPro) return true;
    return mode == PenaltyMode.standard;
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

  Widget _buildQuoteCard(BuildContext context, MotoTheme theme) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final quote = MotivationService.getTodayQuote(locale);

    return GestureDetector(
      onTap: () => ShareService.shareQuote(quote, l10n),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: theme.borderColor.withValues(alpha: 0.5)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.format_quote,
              size: 18,
              color: theme.accentGreen.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                quote,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  color: theme.textSecondary,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms, curve: Curves.easeOut);
  }

  Widget _buildProPromoCard(
    BuildContext context,
    MotoTheme theme,
    AppLocalizations l10n,
  ) {
    const amber = Color(0xFFE5C07B);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProScreen()),
          ).then((_) {
            _loadProStatus();
            _loadPromoCardVisibility();
          });
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                amber.withValues(alpha: 0.18),
                amber.withValues(alpha: 0.08),
              ],
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: amber.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.star, color: amber),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.proPromoCardTitle,
                      style: GoogleFonts.inter(
                        color: amber,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      l10n.proPromoCardSubtitle,
                      style: GoogleFonts.inter(
                        color: theme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  SubscriptionService.dismissPromoCard();
                  setState(() => _showPromoCard = false);
                },
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    Icons.close,
                    size: 16,
                    color: theme.textSecondary.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
                                      builder: (context) => const BadgesScreen(),
                                    ),
                                  ).then((_) => _loadBadgeCount());
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Icon(
                                        Icons.emoji_events_outlined,
                                        color: theme.textSecondary.withValues(
                                          alpha: 0.5,
                                        ),
                                        size: 22,
                                      ),
                                      if (_badgeCount > 0)
                                        Positioned(
                                          right: -4,
                                          top: -4,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 4,
                                              vertical: 1,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFE5C07B),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              '$_badgeCount',
                                              style: GoogleFonts.inter(
                                                fontSize: 9,
                                                fontWeight: FontWeight.w700,
                                                color: theme.bg,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
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
                                  ).then((_) {
                                    _loadHabits();
                                    _loadProStatus();
                                    _loadPromoCardVisibility();
                                  });
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
                        const SizedBox(height: 20),
                        _buildQuoteCard(context, theme),
                        if (_showPromoCard && _habits.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          _buildProPromoCard(context, theme, l10n),
                        ],
                        const SizedBox(height: 16),

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
                              : ReorderableListView.builder(
                                  buildDefaultDragHandles: false,
                                  padding: EdgeInsets.only(
                                    bottom:
                                        MediaQuery.of(
                                          context,
                                        ).viewPadding.bottom +
                                        80,
                                  ),
                                  onReorder: _reorderHabits,
                                  itemCount: _habits.length,
                                  itemBuilder: (context, index) {
                                    final habit = _habits[index];
                                    return Padding(
                                      key: ValueKey(habit.id),
                                      padding: const EdgeInsets.only(bottom: 14),
                                      child: HabitCard(
                                        habit: habit,
                                        reorderIndex: index,
                                        onIncrement: () =>
                                            _incrementStreak(habit.id),
                                        onDecrement: () =>
                                            _decrementStreak(habit.id),
                                        onDelete: () => _deleteHabit(habit.id),
                                        onUpdate: _updateHabit,
                                      ),
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
