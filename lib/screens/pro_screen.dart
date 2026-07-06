import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';
import '../services/iap_service.dart';
import '../services/subscription_service.dart';

class ProScreen extends StatefulWidget {
  const ProScreen({super.key});

  @override
  State<ProScreen> createState() => _ProScreenState();
}

class _ProScreenState extends State<ProScreen> {
  static const _proGold = Color(0xFFE5C07B);

  bool _isLoadingPrices = true;
  bool _isPurchasing = false;
  String? _yearlyPrice;
  String? _monthlyPrice;
  String? _lifetimePrice;
  String? _yearlyPerMonth;
  int? _yearlySavingsPercent;

  @override
  void initState() {
    super.initState();
    _loadPrices();
    _setupPurchaseCallback();
  }

  void _setupPurchaseCallback() {
    IAPService().onPurchaseResult = (success, error) {
      if (!mounted) return;

      setState(() => _isPurchasing = false);

      if (success) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.proActivated),
            backgroundColor: Theme.of(
              context,
            ).extension<MotoTheme>()!.accentGreen,
          ),
        );
      } else if (error != null) {
        // Show error (but not for user cancellation)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: Theme.of(context).extension<MotoTheme>()!.danger,
          ),
        );
      }
    };
  }

  @override
  void dispose() {
    IAPService().onPurchaseResult = null;
    super.dispose();
  }

  Future<void> _loadPrices() async {
    // Initialize IAP and load prices from store
    await IAPService.initialize();

    if (mounted) {
      setState(() {
        _yearlyPrice = IAPService.yearlyPrice;
        _monthlyPrice = IAPService.monthlyPrice;
        _lifetimePrice = IAPService.lifetimePrice;
        _yearlyPerMonth = IAPService.yearlyPerMonthPrice;
        _yearlySavingsPercent = IAPService.yearlySavingsPercent;
        _isLoadingPrices = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context).extension<MotoTheme>()!;

    return PopScope(
      // Block back navigation mid-purchase so this screen stays mounted
      // long enough for onPurchaseResult to fire — otherwise dispose()
      // clears the callback and the success feedback/pop is silently lost
      // (the purchase itself still completes and Pro still gets granted).
      canPop: !_isPurchasing,
      child: Scaffold(
        backgroundColor: theme.bg,
        body: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Close button
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: IconButton(
                          icon: Icon(Icons.close, color: theme.textSecondary),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          // Visual header with squares
                          _buildVisualHeader(theme),

                          const SizedBox(height: 32),

                          // Pro badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  _proGold,
                                  _proGold.withValues(alpha: 0.8),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: _proGold.withValues(alpha: 0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 4),
                                ),
                              ],
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

                          const SizedBox(height: 24),

                          Text(
                            loc.unlockFullPotential,
                            style: GoogleFonts.inter(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              color: theme.textPrimary,
                              height: 1.2,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 12),

                          Text(
                            loc.proDescription,
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              color: theme.textSecondary,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 12),

                          Text(
                            loc.proSocialProof,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: _proGold,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 32),

                          // Features list
                          _buildFeatureCard(
                            theme,
                            icon: Icons.all_inclusive,
                            title: loc.proFeature1,
                            subtitle: '3 → ∞',
                          ),
                          const SizedBox(height: 12),
                          _buildFeatureCard(
                            theme,
                            icon: Icons.psychology_outlined,
                            title: loc.proFeature2,
                            subtitle: '🌱 ⚡ 🔥',
                          ),
                          const SizedBox(height: 12),
                          _buildFeatureCard(
                            theme,
                            icon: Icons.calendar_month_outlined,
                            title: loc.proFeature3,
                            subtitle: '7 → 365+',
                          ),
                          const SizedBox(height: 12),
                          _buildFeatureCard(
                            theme,
                            icon: Icons.notifications_outlined,
                            title: loc.proFeature4,
                            subtitle: '⏰',
                          ),
                          const SizedBox(height: 12),
                          _buildFeatureCard(
                            theme,
                            icon: Icons.color_lens_outlined,
                            title: loc.proFeature5,
                            subtitle: '🌙 ☀️',
                          ),

                          const SizedBox(height: 40),

                          // Pricing section
                          _buildYearlyPricingButton(context, theme, loc),

                          const SizedBox(height: 12),

                          _buildPricingButton(
                            context,
                            theme,
                            title: loc.monthly,
                            price: _monthlyPrice,
                            subtitle: loc.monthlySubtitle,
                            isPrimary: false,
                            isLoading: _isLoadingPrices,
                            onTap: () => _purchase(IAPService.monthlyProductId),
                          ),

                          const SizedBox(height: 16),

                          // Lifetime offer
                          TextButton(
                            onPressed: () =>
                                _purchase(IAPService.lifetimeProductId),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  loc.lifetimeOffer,
                                  style: GoogleFonts.inter(
                                    color: _proGold,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                                if (_isLoadingPrices)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: SizedBox(
                                      width: 12,
                                      height: 12,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: _proGold,
                                      ),
                                    ),
                                  )
                                else if (_lifetimePrice != null)
                                  Text(
                                    ' $_lifetimePrice',
                                    style: GoogleFonts.inter(
                                      color: _proGold,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 8),

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

                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Loading overlay
            if (_isPurchasing)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: CircularProgressIndicator(color: _proGold),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisualHeader(MotoTheme theme) {
    return SizedBox(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Trophy squares
          _buildMiniTrophy(theme, 1),
          const SizedBox(width: 6),
          _buildMiniTrophy(theme, 2),
          const SizedBox(width: 8),
          // Current growing square
          _buildGrowingSquare(theme, 3),
          const SizedBox(width: 8),
          // Future potential
          Opacity(opacity: 0.3, child: _buildGrowingSquare(theme, 4)),
        ],
      ),
    );
  }

  Widget _buildMiniTrophy(MotoTheme theme, int size) {
    const cellSize = 8.0;
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: theme.cardBg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: SizedBox(
        width: size * cellSize + (size - 1) * 2,
        height: size * cellSize + (size - 1) * 2,
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: size,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
          ),
          itemCount: size * size,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: _proGold,
                borderRadius: BorderRadius.circular(1),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildGrowingSquare(MotoTheme theme, int size) {
    const cellSize = 10.0;
    final filled = (size * size * 0.6).floor();
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: theme.cardBg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: SizedBox(
        width: size * cellSize + (size - 1) * 2,
        height: size * cellSize + (size - 1) * 2,
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: size,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
          ),
          itemCount: size * size,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: index < filled ? theme.accentGreen : theme.emptySquare,
                borderRadius: BorderRadius.circular(2),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    MotoTheme theme, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.borderColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _proGold.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: _proGold, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: theme.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            subtitle,
            style: GoogleFonts.inter(fontSize: 14, color: theme.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildYearlyPricingButton(
    BuildContext context,
    MotoTheme theme,
    AppLocalizations loc,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _isPurchasing
            ? null
            : () => _purchase(IAPService.yearlyProductId),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.accentGreen,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: theme.accentGreen.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          loc.yearly,
                          style: GoogleFonts.inter(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: theme.bg,
                          ),
                        ),
                        if (_yearlySavingsPercent != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: theme.bg.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              loc.savePercent(_yearlySavingsPercent!),
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: theme.bg,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Show yearly price prominently, then per-month below
                    if (_isLoadingPrices)
                      Text(
                        loc.yearlySubtitle,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: theme.bg.withValues(alpha: 0.8),
                        ),
                      )
                    else
                      Text(
                        _yearlyPrice ?? '---',
                        style: GoogleFonts.inter(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: theme.bg,
                        ),
                      ),
                  ],
                ),
              ),
              if (_isLoadingPrices)
                SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: theme.bg,
                  ),
                )
              else if (_yearlyPerMonth != null)
                // Show per-month on the right side
                Text(
                  '$_yearlyPerMonth${loc.perMonth}',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: theme.bg.withValues(alpha: 0.9),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPricingButton(
    BuildContext context,
    MotoTheme theme, {
    required String title,
    required String? price,
    required String subtitle,
    required bool isPrimary,
    required bool isLoading,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _isPurchasing ? null : onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isPrimary ? theme.accentGreen : theme.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: isPrimary ? null : Border.all(color: theme.borderColor),
            boxShadow: isPrimary
                ? [
                    BoxShadow(
                      color: theme.accentGreen.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.inter(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: isPrimary ? theme.bg : theme.textPrimary,
                          ),
                        ),
                        if (isPrimary) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: theme.bg.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '⭐ Best',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: theme.bg,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: isPrimary
                            ? theme.bg.withValues(alpha: 0.8)
                            : theme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (isLoading)
                SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: isPrimary ? theme.bg : theme.textSecondary,
                  ),
                )
              else
                Text(
                  price ?? '---',
                  style: GoogleFonts.inter(
                    fontSize: 22,
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

  Future<void> _purchase(String productId) async {
    if (_isPurchasing) return;

    // Check if product is available
    if (IAPService.getProduct(productId) == null) {
      // Products not loaded yet, show error
      if (mounted) {
        final theme = Theme.of(context).extension<MotoTheme>()!;
        final loc = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(loc.productNotAvailable),
            backgroundColor: theme.danger,
          ),
        );
      }
      return;
    }

    setState(() => _isPurchasing = true);

    // Initiate purchase - result will come via callback
    final started = await IAPService.purchase(productId);

    if (!started && mounted) {
      setState(() => _isPurchasing = false);
    }
  }

  Future<void> _restorePurchases(
    BuildContext context,
    AppLocalizations loc,
  ) async {
    if (_isPurchasing) return;

    setState(() => _isPurchasing = true);

    await IAPService.restorePurchases();

    // Check if user is now pro
    await Future.delayed(const Duration(seconds: 2)); // Give time for restore
    final isPro = await SubscriptionService.isPro();

    if (!mounted) return;

    setState(() => _isPurchasing = false);

    final theme = Theme.of(this.context).extension<MotoTheme>()!;

    if (isPro) {
      Navigator.pop(this.context, true);
      ScaffoldMessenger.of(this.context).showSnackBar(
        SnackBar(
          content: Text(loc.proActivated),
          backgroundColor: theme.accentGreen,
        ),
      );
    } else {
      ScaffoldMessenger.of(
        this.context,
      ).showSnackBar(SnackBar(content: Text(loc.noPurchasesFound)));
    }
  }
}
