import 'package:flutter/material.dart';

void main() {
  runApp(const MotoApp());
}

class MotoApp extends StatelessWidget {
  const MotoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Moto',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F0F0F),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Text(
                'Moto',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Construis ta base',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ),
              const SizedBox(height: 32),
              
              // Liste des habitudes (placeholder pour l'instant)
              HabitCard(name: 'Méditation', streak: 0),
              const SizedBox(height: 12),
              HabitCard(name: 'Lecture', streak: 1),
              const SizedBox(height: 12),
              HabitCard(name: 'Sport', streak: 4),
              const SizedBox(height: 12),
              HabitCard(name: 'Code', streak: 9),
              const SizedBox(height: 12),
              HabitCard(name: 'Tmtc', streak: 56),
            ],
          ),
        ),
      ),
    );
  }
}

class HabitCard extends StatelessWidget {
  final String name;
  final int streak;

  const HabitCard({
    super.key,
    required this.name,
    required this.streak,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$streak jours',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
          // Placeholder pour le carré
          HabitProgress(streak: streak),
        ],
      ),
    );
  }
}

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
  void initState() {
    super.initState();
    _scrollController.addListener(_updateScrollState);
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateScrollState());
  }

  void _updateScrollState() {
    if (!_scrollController.hasClients) return;
    setState(() {
      // reverse: true donc la logique est inversée
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
    // Le dernier complété = 75%, les autres dégressifs jusqu'à 30%
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