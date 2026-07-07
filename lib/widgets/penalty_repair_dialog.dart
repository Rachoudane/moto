import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';
import 'celebration_dialog.dart';
import 'moto_san.dart';

/// Shown whenever a penalty was just applied for a missed day. Kind,
/// non-guilt copy: state what happened, note trophies remain, invite to
/// continue — never scold, never frame the miss as an identity.
Future<void> showPenaltyRepairDialog(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  final theme = Theme.of(context).extension<MotoTheme>()!;

  return showCelebrationDialog(
    context: context,
    contentBuilder: (context) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const MotoSan(pose: MotoSanPose.repair, height: 90),
        const SizedBox(height: 18),
        Text(
          l10n.penaltyRepairMessage,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            color: theme.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 15,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 22),
        SizedBox(
          width: double.infinity,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 13),
              decoration: BoxDecoration(
                color: theme.accentGreen,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  l10n.done,
                  style: GoogleFonts.inter(
                    color: theme.bg,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
