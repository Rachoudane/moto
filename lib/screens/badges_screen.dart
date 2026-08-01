import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';
import '../models/app_badge.dart';
import '../services/badge_service.dart';
import '../services/share_service.dart';
import '../services/storage_service.dart';
import '../widgets/badge_medallion.dart';

class BadgesScreen extends StatefulWidget {
  const BadgesScreen({super.key});

  @override
  State<BadgesScreen> createState() => _BadgesScreenState();
}

class _BadgesScreenState extends State<BadgesScreen> {
  List<AppBadge> _unlocked = [];
  Map<BadgeType, (int current, int target)> _progress = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final unlocked = await BadgeService.getUnlocked();
    final habits = await StorageService().loadHabits();
    final progress = BadgeService.progressForAll(habits);
    if (mounted) {
      setState(() {
        _unlocked = unlocked;
        _progress = progress;
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
    HapticFeedback.selectionClick();
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context).extension<MotoTheme>()!;
    final isSecret = secretBadgeTypes.contains(type);
    final isUnlocked = unlocked != null;
    final locale = Localizations.localeOf(context).toString();
    final tier = badgeTiers[type] ?? BadgeTier.special;
    final family = badgeFamilies[type];
    final glow = badgeTierGlow(tier, family);
    final ink = badgeTierInk(tier);
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final labelColor = isDarkTheme ? glow : ink;
    final progress = _progress[type];
    // Show the real (dimmed) icon when a progress ring gives it context;
    // otherwise keep the mystery of a plain lock for behavioral/secret ones.
    final showRealIcon = isUnlocked || progress != null;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 40),
        child: Container(
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BadgeMedallion(
                icon: showRealIcon ? badgeIcons[type]! : Icons.lock_outline,
                tier: isUnlocked ? tier : null,
                family: isUnlocked ? family : null,
                size: 76,
                progress: !isUnlocked && progress != null
                    ? progress.$1 / progress.$2
                    : null,
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: (isUnlocked ? glow : theme.textSecondary).withValues(
                    alpha: 0.15,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isUnlocked ? l10n.badgeUnlockedTitle : l10n.badgeLockedTitle,
                  style: GoogleFonts.inter(
                    color: isUnlocked ? labelColor : theme.textSecondary,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                isSecret && !isUnlocked
                    ? l10n.badgeSecretLockedName
                    : ShareService.badgeName(type, l10n),
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: theme.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 19,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                isSecret && !isUnlocked
                    ? l10n.badgeSecretLockedHint
                    : ShareService.badgeDescription(type, l10n),
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: theme.textSecondary,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
              if (isUnlocked) ...[
                const SizedBox(height: 14),
                Text(
                  l10n.badgeUnlockedOn(
                    DateFormat.yMMMd(locale).format(unlocked.unlockedAt),
                  ),
                  style: GoogleFonts.inter(
                    color: glow,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ] else if (progress != null) ...[
                const SizedBox(height: 14),
                Text(
                  '${progress.$1}/${progress.$2}',
                  style: GoogleFonts.inter(
                    color: theme.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              const SizedBox(height: 24),
              if (isUnlocked) ...[
                SizedBox(
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      ShareService.shareBadge(unlocked, l10n);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      decoration: BoxDecoration(
                        color: theme.accentGreen,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          l10n.shareApp,
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
                const SizedBox(height: 6),
              ],
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  l10n.cancel,
                  style: GoogleFonts.inter(color: theme.textSecondary),
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
                        Icon(
                          Icons.emoji_events,
                          color: const Color(0xFFE5C07B),
                          size: 20,
                        ),
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
                        final tier = badgeTiers[type] ?? BadgeTier.special;
                        final family = badgeFamilies[type];
                        final progress = _progress[type];
                        final showRealIcon = isUnlocked || progress != null;

                        return GestureDetector(
                          onTap: () => _openDetail(type, unlocked),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: theme.cardBg,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isUnlocked
                                    ? badgeTierGlow(
                                        tier,
                                        family,
                                      ).withValues(alpha: 0.4)
                                    : theme.borderColor,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                BadgeMedallion(
                                  icon: showRealIcon
                                      ? badgeIcons[type]!
                                      : Icons.lock_outline,
                                  tier: isUnlocked ? tier : null,
                                  family: isUnlocked ? family : null,
                                  size: 44,
                                  progress: !isUnlocked && progress != null
                                      ? progress.$1 / progress.$2
                                      : null,
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
