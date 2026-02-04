import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';
import '../services/subscription_service.dart';

class ProScreen extends StatelessWidget {
  const ProScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context).extension<MotoTheme>()!;

    return Scaffold(
      backgroundColor: theme.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: theme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),

              // Pro badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFE5C07B),
                      const Color(0xFFE5C07B).withValues(alpha: 0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, color: theme.bg, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Moto Pro',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: theme.bg,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              Text(
                loc.unlockFullPotential,
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: theme.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              Text(
                loc.proDescription,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: theme.textSecondary,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // Features list
              _buildFeatureItem(
                context,
                theme,
                Icons.all_inclusive,
                loc.proFeature1,
              ),
              _buildFeatureItem(
                context,
                theme,
                Icons.psychology_outlined,
                loc.proFeature2,
              ),
              _buildFeatureItem(
                context,
                theme,
                Icons.calendar_month_outlined,
                loc.proFeature3,
              ),
              _buildFeatureItem(
                context,
                theme,
                Icons.notifications_outlined,
                loc.proFeature4,
              ),
              _buildFeatureItem(
                context,
                theme,
                Icons.color_lens_outlined,
                loc.proFeature5,
              ),

              const SizedBox(height: 48),

              // Pricing buttons
              _buildPricingButton(
                context,
                theme,
                title: loc.yearly,
                price: '19,99€',
                subtitle: loc.yearlySubtitle,
                isPrimary: true,
                onTap: () => _purchase(context, theme, loc, 'yearly'),
              ),

              const SizedBox(height: 12),

              _buildPricingButton(
                context,
                theme,
                title: loc.monthly,
                price: '2,99€',
                subtitle: loc.monthlySubtitle,
                isPrimary: false,
                onTap: () => _purchase(context, theme, loc, 'monthly'),
              ),

              const SizedBox(height: 12),

              TextButton(
                onPressed: () => _purchase(context, theme, loc, 'lifetime'),
                child: Text(
                  loc.lifetimeOffer,
                  style: GoogleFonts.inter(
                    color: const Color(0xFFE5C07B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Restore purchases
              TextButton(
                onPressed: () => _restorePurchases(context, loc),
                child: Text(
                  loc.restorePurchases,
                  style: GoogleFonts.inter(
                    color: theme.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(
    BuildContext context,
    MotoTheme theme,
    IconData icon,
    String text,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.accentGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: theme.accentGreen, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(fontSize: 15, color: theme.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingButton(
    BuildContext context,
    MotoTheme theme, {
    required String title,
    required String price,
    required String subtitle,
    required bool isPrimary,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isPrimary ? theme.accentGreen : theme.cardBg,
            borderRadius: BorderRadius.circular(14),
            border: isPrimary ? null : Border.all(color: theme.borderColor),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isPrimary ? theme.bg : theme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: isPrimary
                            ? theme.bg.withValues(alpha: 0.7)
                            : theme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                price,
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: isPrimary ? theme.bg : theme.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _purchase(
    BuildContext context,
    MotoTheme theme,
    AppLocalizations loc,
    String type,
  ) async {
    // TODO: Implement real purchase with RevenueCat or in_app_purchase
    // For now, just simulate a purchase for testing

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          '🧪 Test Mode',
          style: GoogleFonts.inter(color: theme.textPrimary),
        ),
        content: Text(
          'Activate Pro for testing?\n(In production, this will connect to the store)',
          style: GoogleFonts.inter(color: theme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              loc.cancel,
              style: GoogleFonts.inter(color: theme.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Activate',
              style: GoogleFonts.inter(color: theme.accentGreen),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await SubscriptionService.setPro(true);
      if (context.mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(loc.proActivated),
            backgroundColor: theme.accentGreen,
          ),
        );
      }
    }
  }

  Future<void> _restorePurchases(
    BuildContext context,
    AppLocalizations loc,
  ) async {
    // TODO: Implement real restore with RevenueCat or in_app_purchase
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(loc.noPurchasesFound)));
  }
}
