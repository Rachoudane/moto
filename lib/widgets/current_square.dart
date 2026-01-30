import 'package:flutter/material.dart';

class CurrentSquare extends StatefulWidget {
  final int level;
  final int progress;

  const CurrentSquare({
    super.key,
    required this.level,
    required this.progress,
  });

  @override
  State<CurrentSquare> createState() => _CurrentSquareState();
}

class _CurrentSquareState extends State<CurrentSquare>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.4), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.4, end: 0.9), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.0), weight: 30),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _glowAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 60),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void didUpdateWidget(CurrentSquare oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.progress > oldWidget.progress && widget.progress > 0) {
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
    return SizedBox(
      width: 44,
      height: 44,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widget.level,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
        ),
        itemCount: widget.level * widget.level,
        itemBuilder: (context, index) {
          final bool isFilled = index < widget.progress;
          final bool isLastFilled = index == widget.progress - 1 && widget.progress > 0;

          Widget cell = Container(
            decoration: BoxDecoration(
              color: isFilled ? Colors.green[500] : Colors.grey[800],
              borderRadius: BorderRadius.circular(2),
            ),
          );

          if (isLastFilled) {
            return AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green[500],
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: _glowAnimation.value > 0
                          ? [
                              BoxShadow(
                                color: Colors.green.withValues(alpha: 0.6 * _glowAnimation.value),
                                blurRadius: 6 * _glowAnimation.value,
                                spreadRadius: 1 * _glowAnimation.value,
                              ),
                            ]
                          : null,
                    ),
                  ),
                );
              },
            );
          }

          return cell;
        },
      ),
    );
  }
}
