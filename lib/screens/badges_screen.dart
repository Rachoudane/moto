import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';
import '../models/app_badge.dart';
import '../services/badge_service.dart';
import '../services/share_service.dart';

class BadgesScreen extends StatefulWidget {
  const BadgesScreen({super.key});

  @override
  State<BadgesScreen> createState() => _BadgesScreenState();
}

class _BadgesScreenState extends State<BadgesScreen> {
  static const Color _amber = Color(0xFFE5C07B);

  List<AppBadge> _unlocked = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final unlocked = await BadgeService.getUnlocked();
    if (mounted) {
      setState(() {
        _unlocked = unlocked;
        _isLoading = false;
      });
    }
  }

  AppBadge? _unlockedFor(BadgeType type) {
    for (final b in _unlocked) {
      if (b.type == type) return b;
    }
    return null;
  }

  void _openDetail(BadgeType type, AppBadge? unlocked) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context).extension<MotoTheme>()!;
    final isSecret = secretBadgeTypes.contains(type);
    final isUnlocked = unlocked != null;
    final locale = Localizations.localeOf(context).toString();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(
              isUnlocked ? badgeIcons[type] : Icons.lock_outline,
              color: isUnlocked ? _amber : theme.textSecondary,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                isSecret && !isUnlocked
                    ? l10n.badgeSecretLockedName
                    : ShareService.badgeName(type, l10n),
                style: GoogleFonts.inter(
                  color: theme.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isSecret && !isUnlocked
                  ? l10n.badgeSecretLockedHint
                  : ShareService.badgeDescription(type, l10n),
              style: GoogleFonts.inter(color: theme.textSecondary, height: 1.4),
            ),
            if (isUnlocked) ...[
              const SizedBox(height: 14),
              Text(
                l10n.badgeUnlockedOn(
                  DateFormat.yMMMd(locale).format(unlocked.unlockedAt),
                ),
                style: GoogleFonts.inter(
                  color: _amber,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
        actions: [
          if (isUnlocked)
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
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              l10n.cancel,
              style: GoogleFonts.inter(color: theme.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context).extension<MotoTheme>()!;
    final total = BadgeType.values.length;
    final unlockedCount = _unlocked.length;

    return Scaffold(
      backgroundColor: theme.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          l10n.badgesTitle,
          style: GoogleFonts.inter(
            color: theme.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: theme.accentGreen))
          : SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                    child: Row(
                      children: [
                        Icon(Icons.emoji_events, color: _amber, size: 20),
                        const SizedBox(width: 10),
                        Text(
                          l10n.badgesUnlockedCount(unlockedCount, total),
                          style: GoogleFonts.inter(
                            color: theme.textSecondary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.82,
                      ),
                      itemCount: total,
                      itemBuilder: (context, index) {
                        final type = BadgeType.values[index];
                        final unlocked = _unlockedFor(type);
                        final isUnlocked = unlocked != null;
                        final isSecret = secretBadgeTypes.contains(type);

                        return GestureDetector(
                          onTap: () => _openDetail(type, unlocked),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: theme.cardBg,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isUnlocked
                                    ? _amber.withValues(alpha: 0.4)
                                    : theme.borderColor,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  isUnlocked
                                      ? badgeIcons[type]
                                      : Icons.lock_outline,
                                  color: isUnlocked
                                      ? _amber
                                      : theme.textSecondary.withValues(
                                          alpha: 0.4,
                                        ),
                                  size: 26,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  isSecret && !isUnlocked
                                      ? l10n.badgeSecretLockedName
                                      : ShareService.badgeName(type, l10n),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: isUnlocked
                                        ? theme.textPrimary
                                        : theme.textSecondary.withValues(
                                            alpha: 0.5,
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
