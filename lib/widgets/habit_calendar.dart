import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/habit.dart';

class HabitCalendar extends StatelessWidget {
  final Habit habit;

  static const Color accentGreen = Color(0xFF7DD3A8);
  static const Color danger = Color(0xFFF85149);
  static const Color emptySquare = Color(0xFF21262D);
  static const Color textPrimary = Color(0xFFE6EDF3);
  static const Color textSecondary = Color(0xFF7D8590);

  const HabitCalendar({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final todayNorm = DateTime(today.year, today.month, today.day);

    // Build 35 days ending today, aligned to start on Monday
    final endDate = todayNorm;
    // Go back 34 days from today
    final rawStart = endDate.subtract(const Duration(days: 34));
    // Align to previous Monday (weekday 1 = Monday)
    final startDate = rawStart.subtract(Duration(days: rawStart.weekday - 1));
    // Generate all days from startDate up to and including today's week Sunday
    final totalDays = endDate.difference(startDate).inDays + 1;
    // Pad to full weeks
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
            // Weekday headers
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: weekdayHeaders.map((label) {
                return SizedBox(
                  width: cellSize,
                  child: Center(
                    child: Text(
                      label,
                      style: GoogleFonts.inter(
                        color: textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 6),
            // Calendar grid
            Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: days.map((date) {
                final isFuture = date.isAfter(todayNorm);
                final isToday = date == todayNorm;
                final status = habit.getStatusForDate(date);

                Color cellColor;
                if (isFuture) {
                  cellColor = emptySquare.withValues(alpha: 0.3);
                } else {
                  switch (status) {
                    case DayStatus.validated:
                      cellColor = accentGreen;
                    case DayStatus.skipped:
                      cellColor = danger.withValues(alpha: 0.6);
                    case DayStatus.pending:
                      cellColor = emptySquare;
                  }
                }

                return Container(
                  width: cellSize,
                  height: cellSize,
                  decoration: BoxDecoration(
                    color: cellColor,
                    borderRadius: BorderRadius.circular(6),
                    border: isToday
                        ? Border.all(color: textPrimary, width: 2)
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      date.day.toString(),
                      style: GoogleFonts.inter(
                        color: isFuture
                            ? textSecondary.withValues(alpha: 0.3)
                            : status == DayStatus.validated
                                ? const Color(0xFF0A0A0A)
                                : textPrimary.withValues(alpha: 0.8),
                        fontSize: 11,
                        fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }

  List<String> _buildWeekdayHeaders(String locale) {
    // Generate Mon-Sun headers using intl
    final formatter = DateFormat.E(locale);
    // Start from a known Monday (2024-01-01 was a Monday)
    return List.generate(7, (i) {
      final date = DateTime(2024, 1, 1 + i);
      final label = formatter.format(date);
      // Take first 1-2 characters depending on locale
      return label.length > 2 ? label.substring(0, 2) : label;
    });
  }
}
