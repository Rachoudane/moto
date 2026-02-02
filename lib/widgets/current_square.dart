import 'package:flutter/material.dart';

enum CellChangeType { none, gain, lossOne, lossSquare, lossAll }

class CurrentSquare extends StatefulWidget {
  final int level;
  final int progress;
  final CellChangeType changeType;

  const CurrentSquare({
    super.key,
    required this.level,
    required this.progress,
    this.changeType = CellChangeType.none,
  });

  @override
  State<CurrentSquare> createState() => _CurrentSquareState();
}

class _CurrentSquareState extends State<CurrentSquare>
    with TickerProviderStateMixin {
  static const Color accentGreen = Color(0xFF7DD3A8);
  static const Color danger = Color(0xFFF85149);
  static const Color emptySquare = Color(0xFF21262D);
  static const Color emptyBorder = Color(0xFF30363D);

  late AnimationController _gainController;
  late Animation<double> _gainScale;
  late Animation<double> _gainGlow;

  late AnimationController _lossController;
  late Animation<double> _lossShake;
  late Animation<double> _lossFlash;

  @override
  void initState() {
    super.initState();

    // Gain animation
    _gainController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _gainScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.4), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.4, end: 0.9), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.0), weight: 30),
    ]).animate(CurvedAnimation(parent: _gainController, curve: Curves.easeOut));
    _gainGlow = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 60),
    ]).animate(CurvedAnimation(parent: _gainController, curve: Curves.easeOut));

    // Loss animation
    _lossController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _lossShake = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 3.0), weight: 15),
      TweenSequenceItem(tween: Tween(begin: 3.0, end: -3.0), weight: 15),
      TweenSequenceItem(tween: Tween(begin: -3.0, end: 2.0), weight: 15),
      TweenSequenceItem(tween: Tween(begin: 2.0, end: -2.0), weight: 15),
      TweenSequenceItem(tween: Tween(begin: -2.0, end: 1.0), weight: 15),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 25),
    ]).animate(CurvedAnimation(parent: _lossController, curve: Curves.easeOut));
    _lossFlash = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.5), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 0.5, end: 0.0), weight: 30),
    ]).animate(CurvedAnimation(parent: _lossController, curve: Curves.easeOut));
  }

  @override
  void didUpdateWidget(CurrentSquare oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.changeType == CellChangeType.gain && widget.progress > 0) {
      _gainController.forward(from: 0);
    } else if (widget.changeType == CellChangeType.lossOne ||
        widget.changeType == CellChangeType.lossSquare ||
        widget.changeType == CellChangeType.lossAll) {
      _lossController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _gainController.dispose();
    _lossController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_gainController, _lossController]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_lossShake.value, 0),
          child: SizedBox(
            width: 48,
            height: 48,
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
                final bool isLastFilled =
                    index == widget.progress - 1 && widget.progress > 0;

                // Color with loss flash
                Color cellColor;
                if (isFilled) {
                  cellColor = Color.lerp(
                    accentGreen,
                    danger,
                    _lossFlash.value * 0.5,
                  )!;
                } else {
                  cellColor = Color.lerp(
                    emptySquare,
                    danger.withValues(alpha: 0.3),
                    _lossFlash.value * 0.3,
                  )!;
                }

                if (isLastFilled) {
                  return Transform.scale(
                    scale: _gainScale.value,
                    child: Container(
                      decoration: BoxDecoration(
                        color: cellColor,
                        borderRadius: BorderRadius.circular(3),
                        boxShadow: _gainGlow.value > 0
                            ? [
                                BoxShadow(
                                  color: accentGreen.withValues(
                                      alpha: 0.6 * _gainGlow.value),
                                  blurRadius: 6 * _gainGlow.value,
                                  spreadRadius: 1 * _gainGlow.value,
                                ),
                              ]
                            : null,
                      ),
                    ),
                  );
                }

                return Container(
                  decoration: BoxDecoration(
                    color: isFilled ? cellColor : emptySquare,
                    borderRadius: BorderRadius.circular(3),
                    border: isFilled ? null : Border.all(color: emptyBorder, width: 1),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
