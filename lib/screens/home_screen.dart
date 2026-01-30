import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../services/storage_service.dart';
import '../widgets/habit_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StorageService _storageService = StorageService();
  List<Habit> _habits = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    final habits = await _storageService.loadHabits();
    setState(() {
      _habits = habits;
      _isLoading = false;
    });
  }

  Future<void> _saveHabits() async {
    await _storageService.saveHabits(_habits);
  }

  void _incrementStreak(String id) {
    setState(() {
      final habit = _habits.firstWhere((h) => h.id == id);
      habit.streak++;
    });
    _saveHabits();
  }

  void _decrementStreak(String id) {
    setState(() {
      final habit = _habits.firstWhere((h) => h.id == id);

      switch (habit.penaltyMode) {
        case PenaltyMode.zen:
          int level = 1;
          int total = 0;
          while (total + level * level <= habit.streak) {
            total += level * level;
            level++;
          }
          // Perd 1 case
          if (habit.streak > total) {
            habit.streak--;
          }
          break;

        case PenaltyMode.standard:
          // Retour au début du carré en cours (mais pas en dessous)
          int level = 1;
          int total = 0;
          while (total + level * level <= habit.streak) {
            total += level * level;
            level++;
          }
          // Seulement si on a progressé dans le carré
          if (habit.streak > total) {
            habit.streak = total;
          }
          break;

        case PenaltyMode.hardcore:
          // Retour à zéro total
          habit.streak = 0;
          break;
      }
    });
    _saveHabits();
  }

  void _addHabit(String name, bool isQuitting, PenaltyMode penaltyMode) {
    setState(() {
      _habits.add(Habit(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        isQuitting: isQuitting,
        penaltyMode: penaltyMode,
      ));
    });
    _saveHabits();
  }

  void _deleteHabit(String id) {
    setState(() {
      _habits.removeWhere((h) => h.id == id);
    });
    _saveHabits();
  }

  void _updateHabit() {
    setState(() {});
    _saveHabits();
  }

  void _showAddHabitDialog() {
    String name = '';
    bool isQuitting = false;
    PenaltyMode penaltyMode = PenaltyMode.standard;

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
                    'Nouvelle habitude',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    autofocus: true,
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

                  // Type d'habitude
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

                  // Mode de pénalité
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
                  const SizedBox(height: 8),
                  Text(
                    _getModeDescription(penaltyMode),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Bouton créer
                  SizedBox(
                    width: double.infinity,
                    child: GestureDetector(
                      onTap: () {
                        if (name.trim().isNotEmpty) {
                          _addHabit(name.trim(), isQuitting, penaltyMode);
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
                            'Créer',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddHabitDialog,
        backgroundColor: Colors.white,
        child: const Icon(Icons.add, color: Colors.black),
      ),
      body: SafeArea(
        child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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

              // Liste des habitudes
              Expanded(
                child: ListView.separated(
                  itemCount: _habits.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final habit = _habits[index];
                    return HabitCard(
                      habit: habit,
                      onIncrement: () => _incrementStreak(habit.id),
                      onDecrement: () => _decrementStreak(habit.id),
                      onDelete: () => _deleteHabit(habit.id),
                      onUpdate: _updateHabit,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
