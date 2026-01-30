import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../widgets/habit_progress.dart';

class HabitDetailScreen extends StatefulWidget {
  final Habit habit;
  final VoidCallback onUpdate;

  const HabitDetailScreen({
    super.key,
    required this.habit,
    required this.onUpdate,
  });

  @override
  State<HabitDetailScreen> createState() => _HabitDetailScreenState();
}

class _HabitDetailScreenState extends State<HabitDetailScreen> {
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

  (int level, int progress, int totalForNext) _getStats() {
    int level = 1;
    int total = 0;
    while (total + level * level <= widget.habit.streak) {
      total += level * level;
      level++;
    }
    int progress = widget.habit.streak - total;
    int totalForNext = level * level;
    return (level, progress, totalForNext);
  }

  int _getTotalSquaresCompleted() {
    int level = 1;
    int total = 0;
    while (total + level * level <= widget.habit.streak) {
      total += level * level;
      level++;
    }
    return level - 1;
  }

  void _showEditDialog() {
    String name = widget.habit.name;
    bool isQuitting = widget.habit.isQuitting;
    PenaltyMode penaltyMode = widget.habit.penaltyMode;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Modifier l\'habitude',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    initialValue: name,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Nom de l\'habitude',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      filled: true,
                      fillColor: const Color(0xFF0F0F0F),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) => name = value,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setModalState(() => isQuitting = false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: !isQuitting ? Colors.green[700] : const Color(0xFF0F0F0F),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: Text('À faire', style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setModalState(() => isQuitting = true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: isQuitting ? Colors.red[700] : const Color(0xFF0F0F0F),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: Text('À arrêter', style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Mode de pénalité',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildModeButton(
                        setModalState,
                        mode: PenaltyMode.zen,
                        currentMode: penaltyMode,
                        emoji: '🌱',
                        label: 'Zen',
                        onTap: () => setModalState(() => penaltyMode = PenaltyMode.zen),
                      ),
                      const SizedBox(width: 8),
                      _buildModeButton(
                        setModalState,
                        mode: PenaltyMode.standard,
                        currentMode: penaltyMode,
                        emoji: '⚡',
                        label: 'Standard',
                        onTap: () => setModalState(() => penaltyMode = PenaltyMode.standard),
                      ),
                      const SizedBox(width: 8),
                      _buildModeButton(
                        setModalState,
                        mode: PenaltyMode.hardcore,
                        currentMode: penaltyMode,
                        emoji: '🔥',
                        label: 'Hardcore',
                        onTap: () => setModalState(() => penaltyMode = PenaltyMode.hardcore),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: GestureDetector(
                      onTap: () {
                        if (name.trim().isNotEmpty) {
                          setState(() {
                            widget.habit.name = name.trim();
                            widget.habit.isQuitting = isQuitting;
                            widget.habit.penaltyMode = penaltyMode;
                          });
                          widget.onUpdate();
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            'Enregistrer',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildModeButton(
    StateSetter setModalState, {
    required PenaltyMode mode,
    required PenaltyMode currentMode,
    required String emoji,
    required String label,
    required VoidCallback onTap,
  }) {
    final isSelected = mode == currentMode;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white.withValues(alpha: 0.15) : const Color(0xFF0F0F0F),
            borderRadius: BorderRadius.circular(8),
            border: isSelected ? Border.all(color: Colors.white.withValues(alpha: 0.3)) : null,
          ),
          child: Column(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? Colors.white : Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
          widget.habit.name,
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: _showEditDialog,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.habit.isQuitting)
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
            Center(
              child: Transform.scale(
                scale: 2,
                child: HabitProgress(streak: widget.habit.streak),
              ),
            ),
            const SizedBox(height: 48),
            _buildStatCard(
              title: 'Progression actuelle',
              value: '$progress / $totalForNext',
              subtitle: 'Carré $currentLevel×$currentLevel en cours',
            ),
            const SizedBox(height: 12),
            _buildStatCard(
              title: 'Cases totales',
              value: '${widget.habit.streak}',
              subtitle: '$completedSquares carré${completedSquares > 1 ? 's' : ''} complété${completedSquares > 1 ? 's' : ''}',
            ),
            const SizedBox(height: 12),
            _buildStatCard(
              title: 'Mode de pénalité',
              value: _getModeName(widget.habit.penaltyMode),
              subtitle: _getModeDescription(widget.habit.penaltyMode),
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
