import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../main.dart';
import '../models/habit.dart';

class HabitCalendar extends StatelessWidget {
  final Habit habit;
  final int daysToShow;
  final void Function(DateTime date)? onDayTap;

  const HabitCalendar({
    super.key,
    required this.habit,
    this.daysToShow = 35,
    this.onDayTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<MotoTheme>()!;
    final today = DateTime.now();
    final todayNorm = DateTime(today.year, today.month, today.day);

    final endDate = todayNorm;
    final rawStart = endDate.subtract(Duration(days: daysToShow - 1));
    final startDate = rawStart.subtract(Duration(days: rawStart.weekday - 1));
    final totalDays = endDate.difference(startDate).inDays + 1;
    final paddedDays = ((totalDays + 6) ~/ 7) * 7;

    final days = List.generate(paddedDays, (i) {
      return startDate.add(Duration(days: i));
    });

    final locale = Localizations.localeOf(context).toString();
    final weekdayHeaders = _buildWeekdayHeaders(locale);

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final spacing = 4.0;
        final cellSize = (availableWidth - spacing * 6) / 7;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: weekdayHeaders.map((label) {
                return SizedBox(
                  width: cellSize,
                  child: Center(
                    child: Text(
                      label,
                      style: GoogleFonts.inter(
                        color: theme.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: days.map((date) {
                final isFuture = date.isAfter(todayNorm);
                final isToday = date == todayNorm;
                final status = habit.getStatusForDate(date);

                Color cellColor;
                if (isFuture) {
                  cellColor = theme.emptySquare.withValues(alpha: 0.3);
                } else {
                  switch (status) {
                    case DayStatus.validated:
                      cellColor = theme.accentGreen;
                    case DayStatus.skipped:
                      cellColor = theme.danger.withValues(alpha: 0.6);
                    case DayStatus.pending:
                      cellColor = theme.emptySquare;
                  }
                }

                // Text color for validated cells - dark on light theme, dark on dark theme
                final isDark = Theme.of(context).brightness == Brightness.dark;
                final validatedTextColor = isDark ? const Color(0xFF0A0A0A) : const Color(0xFF0A0A0A);

                final cell = Container(
                  width: cellSize,
                  height: cellSize,
                  decoration: BoxDecoration(
                    color: cellColor,
                    borderRadius: BorderRadius.circular(6),
                    border: isToday
                        ? Border.all(color: theme.textPrimary, width: 2)
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      date.day.toString(),
                      style: GoogleFonts.inter(
                        color: isFuture
                            ? theme.textSecondary.withValues(alpha: 0.3)
                            : status == DayStatus.validated
                                ? validatedTextColor
                                : theme.textPrimary.withValues(alpha: 0.8),
                        fontSize: 11,
                        fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
                      ),
                    ),
                  ),
                );

                if (isFuture || onDayTap == null) return cell;
                return GestureDetector(
                  onTap: () => onDayTap!(date),
                  child: cell,
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }

  List<String> _buildWeekdayHeaders(String locale) {
    final formatter = DateFormat.E(locale);
    return List.generate(7, (i) {
      final date = DateTime(2024, 1, 1 + i);
      final label = formatter.format(date);
      return label.length > 2 ? label.substring(0, 2) : label;
    });
  }
}
