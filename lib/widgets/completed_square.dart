import 'package:flutter/material.dart';

class CompletedSquare extends StatefulWidget {
  final int level;
  final int completedLevels;
  final bool animate;
  final bool animateDestroy;

  const CompletedSquare({
    super.key,
    required this.level,
    required this.completedLevels,
    this.animate = false,
    this.animateDestroy = false,
  });

  @override
  State<CompletedSquare> createState() => _CompletedSquareState();
}

class _CompletedSquareState extends State<CompletedSquare>
    with TickerProviderStateMixin {
  static const Color trophyAmber = Color(0xFFE5C07B);
  static const Color danger = Color(0xFFF85149);

  late AnimationController _appearController;
  late Animation<double> _appearScale;
  late Animation<double> _appearGlow;

  late AnimationController _destroyController;
  late Animation<double> _destroyScale;
  late Animation<double> _destroyFlash;

  @override
  void initState() {
    super.initState();

    // Appear bounce
    _appearController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _appearScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.2), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 0.85), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 0.85, end: 1.05), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 1.05, end: 1.0), weight: 15),
    ]).animate(CurvedAnimation(parent: _appearController, curve: Curves.easeOut));
    _appearGlow = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 35),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 65),
    ]).animate(CurvedAnimation(parent: _appearController, curve: Curves.easeOut));

    // Destroy shrink
    _destroyController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _destroyScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.1), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 1.1, end: 0.0), weight: 80),
    ]).animate(CurvedAnimation(parent: _destroyController, curve: Curves.easeIn));
    _destroyFlash = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.6), weight: 70),
    ]).animate(CurvedAnimation(parent: _destroyController, curve: Curves.easeIn));

    if (widget.animate) {
      _appearController.forward();
    }
    if (widget.animateDestroy) {
      _destroyController.forward();
    }
  }

  @override
  void didUpdateWidget(CompletedSquare oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate && !oldWidget.animate) {
      _appearController.forward(from: 0);
    }
    if (widget.animateDestroy && !oldWidget.animateDestroy) {
      _destroyController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _appearController.dispose();
    _destroyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double ratio = 0.3 + (widget.level / widget.completedLevels) * 0.45;
    final double size = 48 * ratio;

    Widget buildGrid(Color color) {
      return SizedBox(
        width: size,
        height: size,
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: widget.level,
            crossAxisSpacing: 1,
            mainAxisSpacing: 1,
          ),
          itemCount: widget.level * widget.level,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            );
          },
        ),
      );
    }

    // Destroy animation
    if (widget.animateDestroy) {
      return AnimatedBuilder(
        animation: _destroyController,
        builder: (context, child) {
          final color = Color.lerp(
            trophyAmber,
            danger,
            _destroyFlash.value,
          )!;
          return Transform.scale(
            scale: _destroyScale.value,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: danger.withValues(alpha: 0.4 * _destroyFlash.value),
                    blurRadius: 8 * _destroyFlash.value,
                    spreadRadius: 1 * _destroyFlash.value,
                  ),
                ],
              ),
              child: buildGrid(color),
            ),
          );
        },
      );
    }

    // Appear animation
    if (widget.animate) {
      return AnimatedBuilder(
        animation: _appearController,
        builder: (context, child) {
          return Transform.scale(
            scale: _appearScale.value,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: _appearGlow.value > 0
                    ? [
                        BoxShadow(
                          color: trophyAmber.withValues(alpha: 0.5 * _appearGlow.value),
                          blurRadius: 10 * _appearGlow.value,
                          spreadRadius: 2 * _appearGlow.value,
                        ),
                      ]
                    : null,
              ),
              child: buildGrid(trophyAmber),
            ),
          );
        },
      );
    }

    return buildGrid(trophyAmber);
  }
}
