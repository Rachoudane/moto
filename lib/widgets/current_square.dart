import 'package:flutter/material.dart';

class CurrentSquare extends StatelessWidget {
  final int level;
  final int progress;

  const CurrentSquare({
    super.key,
    required this.level,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 44,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: level,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
        ),
        itemCount: level * level,
        itemBuilder: (context, index) {
          final bool isFilled = index < progress;
          return Container(
            decoration: BoxDecoration(
              color: isFilled ? Colors.green[500] : Colors.grey[800],
              borderRadius: BorderRadius.circular(2),
            ),
          );
        },
      ),
    );
  }
}
