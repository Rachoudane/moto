import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../main.dart';

/// Shared shell for the app's celebration popups (square completion and
/// badge unlock). Handles the dialog boilerplate — transparent Material
/// wrapper (showGeneralDialog doesn't provide one, unlike showDialog, so
/// without it every Text/Icon below would render with the debug "no
/// Material ancestor" underline), card styling, and fade+scale entrance —
/// so each caller only supplies its own content column.
Future<void> showCelebrationDialog({
  required BuildContext context,
  required WidgetBuilder contentBuilder,
}) {
  final theme = Theme.of(context).extension<MotoTheme>()!;
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'celebration',
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 350),
    pageBuilder: (context, anim1, anim2) {
      return Material(
        type: MaterialType.transparency,
        child: Center(
          child:
              Container(
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    padding: const EdgeInsets.fromLTRB(28, 32, 28, 24),
                    decoration: BoxDecoration(
                      color: theme.cardBg,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: theme.borderColor),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.25),
                          blurRadius: 40,
                          offset: const Offset(0, 20),
                        ),
                      ],
                    ),
                    child: contentBuilder(context),
                  )
                  .animate()
                  .fadeIn(duration: 250.ms)
                  .scale(
                    begin: const Offset(0.9, 0.9),
                    end: const Offset(1, 1),
                    duration: 250.ms,
                  ),
        ),
      );
    },
  );
}
