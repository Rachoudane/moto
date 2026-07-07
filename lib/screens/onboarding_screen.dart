import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';
import '../widgets/completed_square.dart';
import '../widgets/current_square.dart';
import '../widgets/moto_san.dart';
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

    final pageCount = 4;
    final isLastPage = _currentPage == pageCount - 1;

    final pages = [
      _PageEntrance(
        active: _currentPage == 0,
        child: _OnboardingPageShell(
          visual: const _WelcomeVisual(),
          title: loc.onboardingTitle1,
          body: loc.onboardingDesc1,
        ),
      ),
      _PageEntrance(
        active: _currentPage == 1,
        child: _OnboardingPageShell(
          visual: const _ValidateVisual(),
          title: loc.onboardingTitle2,
          body: loc.onboardingDesc2,
        ),
      ),
      _PageEntrance(
        active: _currentPage == 2,
        child: _OnboardingPageShell(
          visual: const _RepairVisual(),
          title: loc.onboardingTitle3,
          body: loc.onboardingDesc3,
          footnote: loc.onboardingModesHint,
        ),
      ),
      _PageEntrance(
        active: _currentPage == 3,
        child: _OnboardingPageShell(
          visual: const _CelebrateVisual(),
          title: loc.onboardingTitle4,
          body: loc.onboardingDesc4,
        ),
      ),
    ];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        // Only treat back-navigation as "finish onboarding" on the last
        // page (equivalent to tapping the final CTA); on earlier pages it
        // should just go back a page, not skip onboarding entirely.
        if (isLastPage) {
          _completeOnboarding();
        } else {
          _pageController.previousPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      },
      child: Scaffold(
        backgroundColor: theme.bg,
        body: SafeArea(
          child: Column(
            children: [
              Visibility(
                visible: !isLastPage,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12, top: 4),
                    child: TextButton(
                      onPressed: _completeOnboarding,
                      child: Text(
                        loc.skip,
                        style: GoogleFonts.inter(
                          color: theme.textSecondary,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
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
                    pageCount,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == index ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? (index == pageCount - 1
                                  ? const Color(0xFFE5C07B)
                                  : theme.accentGreen)
                            : theme.emptySquare,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),

              // Button
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLastPage
                        ? _completeOnboarding
                        : () {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isLastPage
                          ? const Color(0xFFE5C07B)
                          : theme.accentGreen,
                      foregroundColor: theme.bg,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      isLastPage ? loc.onboardingFinalCta : loc.next,
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
}

/// Plays a fade + slight slide-up entrance every time [active] transitions
/// from false to true (i.e. every time the user swipes onto this page), by
/// rekeying the animated subtree so flutter_animate replays from scratch.
/// That rekey also remounts the page's signature animation (wave pulse,
/// grid loop, etc.) so it replays alongside the entrance.
class _PageEntrance extends StatefulWidget {
  final bool active;
  final Widget child;

  const _PageEntrance({required this.active, required this.child});

  @override
  State<_PageEntrance> createState() => _PageEntranceState();
}

class _PageEntranceState extends State<_PageEntrance> {
  int _generation = 0;

  @override
  void didUpdateWidget(covariant _PageEntrance oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active && !oldWidget.active) {
      setState(() => _generation++);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).disableAnimations) {
      return widget.child;
    }
    return widget.child
        .animate(key: ValueKey(_generation))
        .fadeIn(duration: 350.ms, curve: Curves.easeOut)
        .move(
          begin: const Offset(0, 16),
          duration: 350.ms,
          curve: Curves.easeOut,
        );
  }
}

class _OnboardingPageShell extends StatelessWidget {
  final Widget visual;
  final String title;
  final String body;
  final String? footnote;

  const _OnboardingPageShell({
    required this.visual,
    required this.title,
    required this.body,
    this.footnote,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<MotoTheme>()!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          const Spacer(),
          visual,
          const SizedBox(height: 28),
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
            body,
            style: GoogleFonts.inter(
              fontSize: 15,
              color: theme.textSecondary,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          if (footnote != null) ...[
            const SizedBox(height: 14),
            Text(
              footnote!,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: theme.textSecondary.withValues(alpha: 0.7),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          const Spacer(),
        ],
      ),
    );
  }
}

/// Screen 1 — Moto-san fades in, then gives a single gentle wave (a soft
/// scale pulse on the whole character, since the shared SVGs can't be
/// puppeted limb-by-limb).
class _WelcomeVisual extends StatefulWidget {
  const _WelcomeVisual();

  @override
  State<_WelcomeVisual> createState() => _WelcomeVisualState();
}

class _WelcomeVisualState extends State<_WelcomeVisual>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  bool _played = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.06), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.06, end: 1.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_played && !MediaQuery.of(context).disableAnimations) {
      _played = true;
      Future.delayed(const Duration(milliseconds: 450), () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) =>
          Transform.scale(scale: _scale.value, child: child),
      child: const MotoSan(pose: MotoSanPose.welcome, height: 190),
    );
  }
}

/// Screen 2 — a small demo grid loops next to Moto-san: a 1x1 cell fills
/// and becomes a golden trophy, then a 2x2 grid fills cell by cell, then
/// pauses before looping. Reuses the real CurrentSquare/CompletedSquare
/// widgets (driven here by a step timer instead of real habit data).
class _ValidateVisual extends StatefulWidget {
  const _ValidateVisual();

  @override
  State<_ValidateVisual> createState() => _ValidateVisualState();
}

class _ValidateVisualState extends State<_ValidateVisual> {
  static const _stepDurations = [
    Duration(milliseconds: 500),
    Duration(milliseconds: 700),
    Duration(milliseconds: 700),
    Duration(milliseconds: 450),
    Duration(milliseconds: 450),
    Duration(milliseconds: 450),
    Duration(milliseconds: 450),
    Duration(milliseconds: 1400),
  ];

  int _step = 0;
  Timer? _timer;

  void _scheduleNext() {
    _timer = Timer(_stepDurations[_step], () {
      if (!mounted) return;
      setState(() => _step = (_step + 1) % _stepDurations.length);
      _scheduleNext();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_timer == null) {
      if (MediaQuery.of(context).disableAnimations) {
        _step = 7;
      } else {
        _scheduleNext();
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late final Widget cell;
    switch (_step) {
      case 0:
        cell = const CurrentSquare(key: ValueKey('cur1-0'), level: 1, progress: 0);
        break;
      case 1:
        cell = const CurrentSquare(
          key: ValueKey('cur1-1'),
          level: 1,
          progress: 1,
          changeType: CellChangeType.gain,
        );
        break;
      case 2:
        cell = const CompletedSquare(
          key: ValueKey('done1'),
          level: 1,
          completedLevels: 1,
          animate: true,
        );
        break;
      case 3:
        cell = const CurrentSquare(key: ValueKey('cur2-0'), level: 2, progress: 0);
        break;
      case 4:
        cell = const CurrentSquare(
          key: ValueKey('cur2-1'),
          level: 2,
          progress: 1,
          changeType: CellChangeType.gain,
        );
        break;
      case 5:
        cell = const CurrentSquare(
          key: ValueKey('cur2-2'),
          level: 2,
          progress: 2,
          changeType: CellChangeType.gain,
        );
        break;
      case 6:
        cell = const CurrentSquare(
          key: ValueKey('cur2-3'),
          level: 2,
          progress: 3,
          changeType: CellChangeType.gain,
        );
        break;
      case 7:
      default:
        cell = const CompletedSquare(
          key: ValueKey('done2'),
          level: 2,
          completedLevels: 2,
          animate: true,
        );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const MotoSan(pose: MotoSanPose.validate, height: 170),
        const SizedBox(height: 16),
        SizedBox(
          height: 52,
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: cell,
            ),
          ),
        ),
      ],
    );
  }
}

/// Screen 3 — a soft golden halo blooms in behind Moto-san once, echoing
/// the kintsugi (gold repair) motif without needing to animate the SVG.
class _RepairVisual extends StatefulWidget {
  const _RepairVisual();

  @override
  State<_RepairVisual> createState() => _RepairVisualState();
}

class _RepairVisualState extends State<_RepairVisual>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _glow;
  bool _played = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _glow = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.6), weight: 60),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_played) {
      _played = true;
      if (MediaQuery.of(context).disableAnimations) {
        _controller.value = 1;
      } else {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) _controller.forward(from: 0);
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Stack(
        alignment: Alignment.center,
        children: [
          Opacity(
            opacity: 0.4 * _glow.value,
            child: Container(
              width: 160,
              height: 160,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Color(0xFFE5C07B), Colors.transparent],
                ),
              ),
            ),
          ),
          child!,
        ],
      ),
      child: const MotoSan(pose: MotoSanPose.repair, height: 190),
    );
  }
}

/// Screen 4 — 2-3 small gold sparkles twinkle slowly around Moto-san, in a
/// staggered, looping fade.
class _CelebrateVisual extends StatefulWidget {
  const _CelebrateVisual();

  @override
  State<_CelebrateVisual> createState() => _CelebrateVisualState();
}

class _CelebrateVisualState extends State<_CelebrateVisual>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  bool _started = false;

  static const _offsets = [Offset(-58, -68), Offset(56, -46), Offset(28, 44)];

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      _offsets.length,
      (i) => AnimationController(
        duration: Duration(milliseconds: 1400 + i * 220),
        vsync: this,
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_started) {
      _started = true;
      if (MediaQuery.of(context).disableAnimations) {
        for (final c in _controllers) {
          c.value = 1;
        }
      } else {
        for (var i = 0; i < _controllers.length; i++) {
          Future.delayed(Duration(milliseconds: i * 300), () {
            if (mounted) _controllers[i].repeat(reverse: true);
          });
        }
      }
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 210,
      height: 210,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const MotoSan(pose: MotoSanPose.celebrate, height: 190),
          for (var i = 0; i < _offsets.length; i++)
            Positioned(
              left: 105 + _offsets[i].dx,
              top: 105 + _offsets[i].dy,
              child: FadeTransition(
                opacity: Tween<double>(
                  begin: 0.25,
                  end: 1.0,
                ).animate(_controllers[i]),
                child: const Text('✨', style: TextStyle(fontSize: 18)),
              ),
            ),
        ],
      ),
    );
  }
}
