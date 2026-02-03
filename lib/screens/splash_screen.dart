import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';
import 'home_screen.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  final Function(Locale)? onLanguageChanged;
  final Function(bool)? onThemeChanged;
  final bool isDarkMode;

  const SplashScreen({
    super.key,
    this.onLanguageChanged,
    this.onThemeChanged,
    this.isDarkMode = true,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<double> _scale;
  late Animation<double> _taglineFade;
  late List<Animation<double>> _cellAnimations;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
      ),
    );

    _scale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
      ),
    );

    _taglineFade = Tween<double>(begin: 0.0, end: 0.6).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.8, curve: Curves.easeIn),
      ),
    );

    // Pre-build cell animations with safe intervals
    _cellAnimations = List.generate(9, (index) {
      final start = index * 0.05; // 0.0 to 0.40
      final end = (start + 0.4).clamp(0.0, 1.0); // 0.4 to 0.80
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end, curve: Curves.easeOut),
        ),
      );
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _controller.forward();
    });

    Future.delayed(const Duration(milliseconds: 3000), () async {
      if (!mounted) return;
      final prefs = await SharedPreferences.getInstance();
      final onboardingComplete = prefs.getBool('onboarding_complete') ?? false;

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              onboardingComplete
                  ? HomeScreen(
                      onLanguageChanged: widget.onLanguageChanged,
                      onThemeChanged: widget.onThemeChanged,
                      isDarkMode: widget.isDarkMode,
                    )
                  : OnboardingScreen(
                      onLanguageChanged: widget.onLanguageChanged,
                      onThemeChanged: widget.onThemeChanged,
                      isDarkMode: widget.isDarkMode,
                    ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<MotoTheme>()!;

    return Scaffold(
      body: SizedBox.expand(
        child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [theme.bg, theme.cardBg],
          ),
        ),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),

                FadeTransition(
                  opacity: _fadeIn,
                  child: ScaleTransition(
                    scale: _scale,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: theme.accentGreen.withValues(alpha: 0.3 * _fadeIn.value),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: _buildLogo(theme),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                FadeTransition(
                  opacity: _fadeIn,
                  child: Text(
                    'Moto',
                    style: GoogleFonts.inter(
                      fontSize: 42,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                      color: theme.textPrimary,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                FadeTransition(
                  opacity: _fadeIn,
                  child: Text(
                    '元',
                    style: TextStyle(
                      fontSize: 24,
                      color: theme.textPrimary.withValues(alpha: 0.5),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                FadeTransition(
                  opacity: _fadeIn,
                  child: Container(
                    width: 60,
                    height: 3,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [theme.accentGreen, theme.accentGreen.withValues(alpha: 0.3)],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const Spacer(),

                FadeTransition(
                  opacity: _taglineFade,
                  child: Builder(
                    builder: (context) {
                      final l10n = AppLocalizations.of(context);
                      return Text(
                        l10n?.buildYourBase ?? '',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: theme.textPrimary.withValues(alpha: 0.4),
                          fontStyle: FontStyle.italic,
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 60),
              ],
            );
          },
        ),
      ),
      ),
    );
  }

  Widget _buildLogo(MotoTheme theme) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      crossAxisCount: 3,
      crossAxisSpacing: 6,
      mainAxisSpacing: 6,
      children: List.generate(9, (index) {
        return AnimatedBuilder(
          animation: _cellAnimations[index],
          builder: (context, child) {
            return Transform.scale(
              scale: _cellAnimations[index].value,
              child: Container(
                decoration: BoxDecoration(
                  color: index < 7 ? theme.accentGreen : theme.emptySquare,
                  borderRadius: BorderRadius.circular(8),
                  border: index >= 7
                      ? Border.all(color: theme.emptyBorder, width: 1)
                      : null,
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
