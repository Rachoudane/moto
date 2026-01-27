import 'package:flutter/material.dart';

class CompletedSquare extends StatelessWidget {
  final int level;
  final int completedLevels;

  const CompletedSquare({
    super.key,
    required this.level,
    required this.completedLevels,
  });

  @override
  Widget build(BuildContext context) {
    final double ratio = 0.3 + (level / completedLevels) * 0.45;
    final double size = 44 * ratio;

    return SizedBox(
      width: size,
      height: size,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: level,
          crossAxisSpacing: 1,
          mainAxisSpacing: 1,
        ),
        itemCount: level * level,
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
  }
}
