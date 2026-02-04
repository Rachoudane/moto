import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  final Function(Locale)? onLanguageChanged;
  final Function(bool)? onThemeChanged;
  final bool isDarkMode;

  const OnboardingScreen({
    super.key,
    this.onLanguageChanged,
    this.onThemeChanged,
    this.isDarkMode = true,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => HomeScreen(
            onLanguageChanged: widget.onLanguageChanged,
            onThemeChanged: widget.onThemeChanged,
            isDarkMode: widget.isDarkMode,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<MotoTheme>()!;
    final loc = AppLocalizations.of(context)!;

    final pages = [
      _OnboardingPage(
        title: loc.onboardingTitle1,
        description: loc.onboardingDesc1,
        child: _buildWelcomeVisual(theme),
      ),
      _OnboardingPage(
        title: loc.onboardingTitle2,
        description: loc.onboardingDesc2,
        child: _buildSquaresVisual(theme),
      ),
      _OnboardingPage(
        title: loc.onboardingTitle3,
        description: loc.onboardingDesc3,
        child: _buildProgressVisual(theme),
      ),
      _OnboardingPage(
        title: loc.onboardingTitle4,
        description: loc.onboardingDesc4,
        child: _buildModesVisual(theme, loc),
      ),
    ];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _completeOnboarding();
        }
      },
      child: Scaffold(
        backgroundColor: theme.bg,
        body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextButton(
                  onPressed: _completeOnboarding,
                  child: Text(
                    loc.skip,
                    style: GoogleFonts.inter(
                      color: theme.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),

            // Page content
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: pages,
              ),
            ),

            // Page indicators
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  pages.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? theme.accentGreen
                          : theme.emptySquare,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),

            // Next/Start button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_currentPage == pages.length - 1) {
                      _completeOnboarding();
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.accentGreen,
                    foregroundColor: theme.bg,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    _currentPage == pages.length - 1
                        ? loc.getStarted
                        : loc.next,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }

  Widget _buildWelcomeVisual(MotoTheme theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '元',
          style: GoogleFonts.notoSansJp(
            fontSize: 80,
            fontWeight: FontWeight.w300,
            color: theme.accentGreen,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Moto',
          style: GoogleFonts.inter(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: theme.textPrimary,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildSquaresVisual(MotoTheme theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildSquare(theme, 1, filled: 1),
        const SizedBox(width: 12),
        _buildSquare(theme, 2, filled: 4),
        const SizedBox(width: 12),
        _buildSquare(theme, 3, filled: 7),
      ],
    );
  }

  Widget _buildSquare(MotoTheme theme, int size, {required int filled}) {
    final cellSize = 20.0 - (size * 2);
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.cardBg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: SizedBox(
        width: size * cellSize + (size - 1) * 4,
        height: size * cellSize + (size - 1) * 4,
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: size,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemCount: size * size,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: index < filled ? theme.accentGreen : theme.emptySquare,
                borderRadius: BorderRadius.circular(3),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProgressVisual(MotoTheme theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Completed squares (trophies)
        _buildTrophySquare(theme, 1),
        const SizedBox(width: 8),
        _buildTrophySquare(theme, 2),
        const SizedBox(width: 12),
        // Current square
        _buildSquare(theme, 3, filled: 5),
      ],
    );
  }

  Widget _buildTrophySquare(MotoTheme theme, int size) {
    const trophyAmber = Color(0xFFE5C07B);
    final cellSize = 12.0 - (size * 1);
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
                color: trophyAmber,
                borderRadius: BorderRadius.circular(2),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildModesVisual(MotoTheme theme, AppLocalizations loc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildModeCard(theme, '🌱', loc.zen, theme.accentGreen),
        const SizedBox(width: 12),
        _buildModeCard(theme, '⚡', loc.standard, theme.textPrimary),
        const SizedBox(width: 12),
        _buildModeCard(theme, '🔥', loc.hardcore, theme.danger),
      ],
    );
  }

  Widget _buildModeCard(
      MotoTheme theme, String emoji, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final Widget child;

  const _OnboardingPage({
    required this.title,
    required this.description,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<MotoTheme>()!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          const Spacer(),
          SizedBox(
            height: 200,
            child: child,
          ),
          const Spacer(),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: theme.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: GoogleFonts.inter(
              fontSize: 15,
              color: theme.textSecondary,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
