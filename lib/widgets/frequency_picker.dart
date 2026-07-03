import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';

/// Lets the user choose which weekdays a habit is scheduled on (0=Mon..6=Sun).
/// Defaults to "every day" (all 7 selected) so existing behavior is unchanged
/// unless the user opts into a specific recurrence.
class FrequencyPicker extends StatelessWidget {
  final Set<int> selectedWeekdays;
  final ValueChanged<Set<int>> onChanged;

  const FrequencyPicker({
    super.key,
    required this.selectedWeekdays,
    required this.onChanged,
  });

  bool get _isDaily => selectedWeekdays.length >= 7;

  List<String> _dayInitials(String locale) {
    final formatter = DateFormat.E(locale);
    return List.generate(7, (i) {
      // 2024-01-01 is a Monday, so index 0..6 maps directly to Mon..Sun.
      final label = formatter.format(DateTime(2024, 1, 1 + i));
      return label.isNotEmpty ? label.substring(0, 1).toUpperCase() : '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context).extension<MotoTheme>()!;
    final locale = Localizations.localeOf(context).toString();
    final initials = _dayInitials(locale);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.frequency,
          style: GoogleFonts.inter(fontSize: 14, color: theme.textSecondary),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _ToggleChip(
                label: l10n.everyDay,
                selected: _isDaily,
                theme: theme,
                onTap: () => onChanged({0, 1, 2, 3, 4, 5, 6}),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _ToggleChip(
                label: l10n.specificDays,
                selected: !_isDaily,
                theme: theme,
                onTap: () {
                  if (_isDaily) {
                    // Seed with a sensible default (today) instead of an
                    // empty set so the habit still has an active schedule.
                    final today = DateTime.now().weekday - 1;
                    onChanged({today});
                  }
                },
              ),
            ),
          ],
        ),
        if (!_isDaily) ...[
          const SizedBox(height: 12),
          Row(
            children: List.generate(7, (i) {
              final isSelected = selectedWeekdays.contains(i);
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: i == 6 ? 0 : 6),
                  child: GestureDetector(
                    onTap: () {
                      final updated = {...selectedWeekdays};
                      if (isSelected) {
                        // Always keep at least one active day.
                        if (updated.length > 1) updated.remove(i);
                      } else {
                        updated.add(i);
                      }
                      onChanged(updated);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? theme.accentGreen.withValues(alpha: 0.2)
                            : theme.bg,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected
                              ? theme.accentGreen.withValues(alpha: 0.4)
                              : theme.borderColor,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          initials[i],
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? theme.accentGreen
                                : theme.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }
}

class _ToggleChip extends StatelessWidget {
  final String label;
  final bool selected;
  final MotoTheme theme;
  final VoidCallback onTap;

  const _ToggleChip({
    required this.label,
    required this.selected,
    required this.theme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? theme.accentGreen.withValues(alpha: 0.2)
              : theme.bg,
          borderRadius: BorderRadius.circular(10),
          border: selected
              ? Border.all(color: theme.accentGreen.withValues(alpha: 0.4))
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: selected ? theme.accentGreen : theme.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

/// Human-readable summary of a schedule, e.g. "Every day" or "Mon, Wed, Fri".
String frequencySummary(
  AppLocalizations l10n,
  String locale,
  Set<int> scheduledWeekdays,
) {
  if (scheduledWeekdays.length >= 7) return l10n.everyDay;
  final formatter = DateFormat.E(locale);
  final sorted = scheduledWeekdays.toList()..sort();
  return sorted
      .map((i) => formatter.format(DateTime(2024, 1, 1 + i)))
      .join(', ');
}
