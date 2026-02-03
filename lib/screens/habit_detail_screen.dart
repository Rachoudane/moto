import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_localizations.dart';
import '../models/habit.dart';
import '../services/notification_service.dart';
import '../widgets/habit_calendar.dart';
import '../widgets/habit_progress.dart';

class HabitDetailScreen extends StatefulWidget {
  final Habit habit;
  final VoidCallback onUpdate;

  const HabitDetailScreen({
    super.key,
    required this.habit,
    required this.onUpdate,
  });

  @override
  State<HabitDetailScreen> createState() => _HabitDetailScreenState();
}

class _HabitDetailScreenState extends State<HabitDetailScreen> {
  static const Color bg = Color(0xFF0A0A0A);
  static const Color cardBg = Color(0xFF161B22);
  static const Color accentGreen = Color(0xFF7DD3A8);
  static const Color danger = Color(0xFFF85149);
  static const Color textPrimary = Color(0xFFE6EDF3);
  static const Color textSecondary = Color(0xFF7D8590);

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
      case 0: return l10n.monday;
      case 1: return l10n.tuesday;
      case 2: return l10n.wednesday;
      case 3: return l10n.thursday;
      case 4: return l10n.friday;
      case 5: return l10n.saturday;
      case 6: return l10n.sunday;
      default: return '';
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

  void _showDeleteConfirmation() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          l10n.deleteHabit,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
        ),
        content: Text(
          l10n.deleteHabitConfirm(widget.habit.streak),
          style: GoogleFonts.inter(
            fontSize: 14,
            color: textSecondary,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              l10n.cancel,
              style: GoogleFonts.inter(
                color: accentGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              widget.onUpdate();
            },
            child: Text(
              l10n.delete,
              style: GoogleFonts.inter(
                color: danger,
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
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + MediaQuery.of(context).viewPadding.bottom + 24,
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
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    initialValue: name,
                    style: GoogleFonts.inter(color: textPrimary),
                    decoration: InputDecoration(
                      hintText: l10n.habitName,
                      hintStyle: GoogleFonts.inter(color: textSecondary),
                      filled: true,
                      fillColor: bg,
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
                              color: !isQuitting ? accentGreen.withValues(alpha: 0.2) : bg,
                              borderRadius: BorderRadius.circular(10),
                              border: !isQuitting ? Border.all(color: accentGreen.withValues(alpha: 0.4)) : null,
                            ),
                            child: Center(
                              child: Text(l10n.toDo, style: GoogleFonts.inter(
                                color: !isQuitting ? accentGreen : textSecondary,
                                fontWeight: FontWeight.w500,
                              )),
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
                              color: isQuitting ? danger.withValues(alpha: 0.2) : bg,
                              borderRadius: BorderRadius.circular(10),
                              border: isQuitting ? Border.all(color: danger.withValues(alpha: 0.4)) : null,
                            ),
                            child: Center(
                              child: Text(l10n.toQuit, style: GoogleFonts.inter(
                                color: isQuitting ? danger : textSecondary,
                                fontWeight: FontWeight.w500,
                              )),
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
                      color: textSecondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _buildModeButton(
                        setModalState,
                        mode: PenaltyMode.zen,
                        currentMode: penaltyMode,
                        emoji: '🌱',
                        label: l10n.zen,
                        onTap: () => setModalState(() => penaltyMode = PenaltyMode.zen),
                      ),
                      const SizedBox(width: 8),
                      _buildModeButton(
                        setModalState,
                        mode: PenaltyMode.standard,
                        currentMode: penaltyMode,
                        emoji: '⚡',
                        label: l10n.standard,
                        onTap: () => setModalState(() => penaltyMode = PenaltyMode.standard),
                      ),
                      const SizedBox(width: 8),
                      _buildModeButton(
                        setModalState,
                        mode: PenaltyMode.hardcore,
                        currentMode: penaltyMode,
                        emoji: '🔥',
                        label: l10n.hardcore,
                        onTap: () => setModalState(() => penaltyMode = PenaltyMode.hardcore),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: GestureDetector(
                      onTap: () {
                        if (name.trim().isNotEmpty) {
                          setState(() {
                            widget.habit.name = name.trim();
                            widget.habit.isQuitting = isQuitting;
                            widget.habit.penaltyMode = penaltyMode;
                          });
                          widget.onUpdate();
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: accentGreen,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            l10n.save,
                            style: GoogleFonts.inter(
                              color: const Color(0xFF0A0A0A),
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
                          color: danger.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: danger.withValues(alpha: 0.3)),
                        ),
                        child: Center(
                          child: Text(
                            l10n.delete,
                            style: GoogleFonts.inter(
                              color: danger,
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
    StateSetter setModalState, {
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
            color: isSelected ? textPrimary.withValues(alpha: 0.1) : bg,
            borderRadius: BorderRadius.circular(10),
            border: isSelected ? Border.all(color: textPrimary.withValues(alpha: 0.2)) : null,
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
                  color: isSelected ? textPrimary : textSecondary,
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
    final habit = widget.habit;
    final locale = Localizations.localeOf(context).languageCode;

    String timeText = l10n.noReminder;
    if (habit.reminderEnabled && habit.reminderHour != null && habit.reminderMinute != null) {
      timeText = "${habit.reminderHour!.toString().padLeft(2, '0')}:${habit.reminderMinute!.toString().padLeft(2, '0')}";
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF21262D)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.notifications_outlined,
                    size: 18,
                    color: textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.reminder,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: textPrimary,
                    ),
                  ),
                ],
              ),
              Switch(
                value: habit.reminderEnabled,
                onChanged: (value) async {
                  if (value) {
                    final hasPermission = await NotificationService.requestPermission();
                    if (!hasPermission) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.permissionRequired)),
                        );
                      }
                      return;
                    }
                  }
                  setState(() {
                    habit.reminderEnabled = value;
                    if (!value) {
                      NotificationService.cancelHabitReminder(habit.id);
                    } else if (habit.reminderHour != null && habit.reminderMinute != null) {
                      NotificationService.scheduleHabitReminder(
                        habit: habit,
                        hour: habit.reminderHour!,
                        minute: habit.reminderMinute!,
                        locale: locale,
                      );
                    }
                  });
                  widget.onUpdate();
                },
                activeTrackColor: accentGreen,
              ),
            ],
          ),
          if (habit.reminderEnabled) ...[
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay(
                    hour: habit.reminderHour ?? 9,
                    minute: habit.reminderMinute ?? 0,
                  ),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.dark(
                          primary: accentGreen,
                          surface: cardBg,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (time != null) {
                  setState(() {
                    habit.reminderHour = time.hour;
                    habit.reminderMinute = time.minute;
                  });
                  await NotificationService.scheduleHabitReminder(
                    habit: habit,
                    hour: time.hour,
                    minute: time.minute,
                    locale: locale,
                  );
                  widget.onUpdate();
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF21262D),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.reminderTime,
                      style: GoogleFonts.inter(color: textSecondary),
                    ),
                    Text(
                      timeText,
                      style: GoogleFonts.inter(
                        color: textPrimary,
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

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.habit.name,
          style: GoogleFonts.inter(
            color: textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: textSecondary),
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
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: danger.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: danger.withValues(alpha: 0.3)),
                ),
                child: Text(
                  l10n.toQuit,
                  style: GoogleFonts.inter(color: danger, fontSize: 12, fontWeight: FontWeight.w500),
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
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            HabitCalendar(habit: widget.habit),
            const SizedBox(height: 32),
            _buildStatCard(
              title: l10n.penaltyMode,
              value: _getModeName(l10n, widget.habit.penaltyMode),
              subtitle: _getModeDescription(l10n, widget.habit.penaltyMode),
            ),
            const SizedBox(height: 16),
            _buildReminderCard(context),
            const SizedBox(height: 32),
            Text(
              l10n.statistics,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildAdvancedStatCard(
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
                    title: l10n.successRate,
                    value: "${widget.habit.successRate.toStringAsFixed(0)}%",
                    subtitle: "${widget.habit.totalValidatedDays} ${l10n.days}",
                    icon: Icons.trending_up_outlined,
                    iconColor: accentGreen,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildAdvancedStatCard(
                    title: l10n.bestDay,
                    value: widget.habit.bestDayOfWeek != null 
                        ? _getDayName(l10n, widget.habit.bestDayOfWeek!)
                        : "-",
                    subtitle: widget.habit.bestDayOfWeek != null 
                        ? "" 
                        : l10n.noDataYet,
                    icon: Icons.calendar_today_outlined,
                    iconColor: accentGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildAdvancedStatCard(
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
                    title: l10n.totalCells,
                    value: '${widget.habit.streak}',
                    subtitle: l10n.completedSquares(completedSquares),
                    icon: Icons.grid_on_outlined,
                    iconColor: accentGreen,
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

  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFF30363D).withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: textSecondary.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFF30363D).withValues(alpha: 0.5),
        ),
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
                    color: textSecondary,
                  ),
                ),
              ),
              Icon(
                icon,
                size: 16,
                color: iconColor,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: textSecondary.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
