import 'package:flutter/material.dart';
import 'completed_square.dart';
import 'current_square.dart';

class HabitProgress extends StatefulWidget {
  final int streak;

  const HabitProgress({super.key, required this.streak});

  @override
  State<HabitProgress> createState() => _HabitProgressState();
}

class _HabitProgressState extends State<HabitProgress> {
  final ScrollController _scrollController = ScrollController();
  bool _canScrollLeft = false;
  bool _canScrollRight = false;

  // Animation states
  bool _justCompleted = false;
  bool _destroyingSquares = false;
  CellChangeType _changeType = CellChangeType.none;

  // Override display to show full square before completion transition
  int? _overrideLevel;
  int? _overrideProgress;
  int? _overrideCompleted;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateScrollState);
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateScrollState());
  }

  @override
  void didUpdateWidget(HabitProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.streak == widget.streak) return;

    final (oldLevel, oldProg, oldCompleted) = _getProgressFor(oldWidget.streak);
    final (_, _, newCompleted) = _getProgressFor(widget.streak);

    if (widget.streak > oldWidget.streak) {
      // === GAIN ===
      if (newCompleted > oldCompleted) {
        // Square just completed! Show the square fully filled first, then bounce
        setState(() {
          _overrideLevel = oldLevel;
          _overrideProgress = oldLevel * oldLevel; // all cells filled
          _overrideCompleted = oldCompleted;
          _changeType = CellChangeType.gain;
        });

        // After the cell pulse, switch to completed state with bounce
        Future.delayed(const Duration(milliseconds: 350), () {
          if (!mounted) return;
          setState(() {
            _overrideLevel = null;
            _overrideProgress = null;
            _overrideCompleted = null;
            _justCompleted = true;
            _changeType = CellChangeType.none;
          });

          Future.delayed(const Duration(milliseconds: 700), () {
            if (mounted) setState(() => _justCompleted = false);
          });
        });
      } else {
        setState(() {
          _changeType = CellChangeType.gain;
          _overrideLevel = null;
          _overrideProgress = null;
          _overrideCompleted = null;
        });
        Future.delayed(const Duration(milliseconds: 450), () {
          if (mounted) setState(() => _changeType = CellChangeType.none);
        });
      }
    } else {
      // === LOSS ===
      CellChangeType lossType;
      if (widget.streak == 0 && oldWidget.streak > 0) {
        lossType = CellChangeType.lossAll;
      } else if (newCompleted < oldCompleted) {
        lossType = CellChangeType.lossSquare;
      } else {
        lossType = CellChangeType.lossOne;
      }

      // If we lost completed squares, animate their destruction
      if (newCompleted < oldCompleted) {
        setState(() {
          _destroyingSquares = true;
          _changeType = lossType;
          _overrideLevel = null;
          _overrideProgress = null;
          _overrideCompleted = null;
        });
        Future.delayed(const Duration(milliseconds: 550), () {
          if (mounted) setState(() => _destroyingSquares = false);
        });
      } else {
        setState(() {
          _changeType = lossType;
          _overrideLevel = null;
          _overrideProgress = null;
          _overrideCompleted = null;
        });
      }

      Future.delayed(const Duration(milliseconds: 550), () {
        if (mounted) setState(() => _changeType = CellChangeType.none);
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => _updateScrollState());
  }

  (int level, int progress, int completedLevels) _getProgressFor(int streak) {
    if (streak <= 0) return (1, 0, 0);
    int level = 1;
    int remaining = streak;
    while (remaining >= level * level) {
      remaining -= level * level;
      level++;
    }
    return (level, remaining, level - 1);
  }

  void _updateScrollState() {
    if (!_scrollController.hasClients) return;
    setState(() {
      _canScrollLeft = _scrollController.position.pixels <
          _scrollController.position.maxScrollExtent - 1;
      _canScrollRight = _scrollController.position.pixels > 1;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final (calcLevel, calcProgress, calcCompleted) =
        _getProgressFor(widget.streak);

    final currentLevel = _overrideLevel ?? calcLevel;
    final progress = _overrideProgress ?? calcProgress;
    final completedLevels = _overrideCompleted ?? calcCompleted;

    return SizedBox(
      width: 180,
      height: 44,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (completedLevels > 0)
            Flexible(
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      _canScrollLeft ? Colors.transparent : Colors.white,
                      Colors.white,
                      Colors.white,
                      _canScrollRight ? Colors.transparent : Colors.white,
                    ],
                    stops: const [0.0, 0.15, 0.85, 1.0],
                  ).createShader(bounds);
                },
                blendMode: BlendMode.dstIn,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      for (int i = 1; i <= completedLevels; i++)
                        Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: CompletedSquare(
                            level: i,
                            completedLevels: completedLevels,
                            animate: _justCompleted && i == completedLevels,
                            animateDestroy:
                                _destroyingSquares && i == completedLevels,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          CurrentSquare(
            level: currentLevel,
            progress: progress,
            changeType: _changeType,
          ),
        ],
      ),
    );
  }
}
