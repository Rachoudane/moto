import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../widgets/habit_progress.dart';

class HabitDetailScreen extends StatelessWidget {
  final Habit habit;

  const HabitDetailScreen({super.key, required this.habit});

  String _getModeName(PenaltyMode mode) {
    switch (mode) {
      case PenaltyMode.zen:
        return '🌱 Zen';
      case PenaltyMode.standard:
        return '⚡ Standard';
      case PenaltyMode.hardcore:
        return '🔥 Hardcore';
    }
  }

  String _getModeDescription(PenaltyMode mode) {
    switch (mode) {
      case PenaltyMode.zen:
        return 'Perd 1 case en cas d\'échec';
      case PenaltyMode.standard:
        return 'Perd le carré en cours en cas d\'échec';
      case PenaltyMode.hardcore:
        return 'Retour à zéro total en cas d\'échec';
    }
  }

  // Calcule les stats
  (int level, int progress, int totalForNext) _getStats() {
    int level = 1;
    int total = 0;
    while (total + level * level <= habit.streak) {
      total += level * level;
      level++;
    }
    int progress = habit.streak - total;
    int totalForNext = level * level;
    return (level, progress, totalForNext);
  }

  int _getTotalSquaresCompleted() {
    int level = 1;
    int total = 0;
    while (total + level * level <= habit.streak) {
      total += level * level;
      level++;
    }
    return level - 1;
  }

  @override
  Widget build(BuildContext context) {
    final (currentLevel, progress, totalForNext) = _getStats();
    final completedSquares = _getTotalSquaresCompleted();

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          habit.name,
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Type d'habitude
            if (habit.isQuitting)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red[900],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'À arrêter',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            const SizedBox(height: 24),

            // Progression visuelle (grande)
            Center(
              child: Transform.scale(
                scale: 2,
                child: HabitProgress(streak: habit.streak),
              ),
            ),
            const SizedBox(height: 48),

            // Stats
            _buildStatCard(
              title: 'Progression actuelle',
              value: '$progress / $totalForNext',
              subtitle: 'Carré $currentLevel×$currentLevel en cours',
            ),
            const SizedBox(height: 12),
            _buildStatCard(
              title: 'Cases totales',
              value: '${habit.streak}',
              subtitle: '$completedSquares carré${completedSquares > 1 ? 's' : ''} complété${completedSquares > 1 ? 's' : ''}',
            ),
            const SizedBox(height: 12),
            _buildStatCard(
              title: 'Mode de pénalité',
              value: _getModeName(habit.penaltyMode),
              subtitle: _getModeDescription(habit.penaltyMode),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
