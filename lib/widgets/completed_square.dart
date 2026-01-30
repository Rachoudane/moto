import 'package:flutter/material.dart';

class CompletedSquare extends StatefulWidget {
  final int level;
  final int completedLevels;
  final bool animate;

  const CompletedSquare({
    super.key,
    required this.level,
    required this.completedLevels,
    this.animate = false,
  });

  @override
  State<CompletedSquare> createState() => _CompletedSquareState();
}

class _CompletedSquareState extends State<CompletedSquare>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.2), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 0.85), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 0.85, end: 1.05), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 1.05, end: 1.0), weight: 15),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _glowAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 35),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 65),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    if (widget.animate) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(CompletedSquare oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate && !oldWidget.animate) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double ratio = 0.3 + (widget.level / widget.completedLevels) * 0.45;
    final double size = 44 * ratio;

    Widget square = SizedBox(
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
              color: Colors.amber[600],
              borderRadius: BorderRadius.circular(1),
            ),
          );
        },
      ),
    );

    if (!widget.animate) return square;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: _glowAnimation.value > 0
                  ? [
                      BoxShadow(
                        color: Colors.amber.withValues(alpha: 0.5 * _glowAnimation.value),
                        blurRadius: 10 * _glowAnimation.value,
                        spreadRadius: 2 * _glowAnimation.value,
                      ),
                    ]
                  : null,
            ),
            child: SizedBox(
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
                      color: Colors.amber[600],
                      borderRadius: BorderRadius.circular(1),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
