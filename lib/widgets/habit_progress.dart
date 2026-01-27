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

  @override
  void didUpdateWidget(HabitProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.streak != widget.streak) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _updateScrollState());
    }
  }
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateScrollState);
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateScrollState());
  }

  void _updateScrollState() {
    if (!_scrollController.hasClients) return;
    setState(() {
      _canScrollLeft = _scrollController.position.pixels < _scrollController.position.maxScrollExtent - 1;
      _canScrollRight = _scrollController.position.pixels > 1;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  (int level, int progress, int completedLevels) getProgress() {
    if (widget.streak <= 0) return (1, 0, 0);

    int level = 1;
    int remaining = widget.streak;

    while (remaining >= level * level) {
      remaining -= level * level;
      level++;
    }

    return (level, remaining, level - 1);
  }

  @override
  Widget build(BuildContext context) {
    final (currentLevel, progress, completedLevels) = getProgress();

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
                          child: CompletedSquare(level: i, completedLevels: completedLevels),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          CurrentSquare(level: currentLevel, progress: progress),
        ],
      ),
    );
  }
}
