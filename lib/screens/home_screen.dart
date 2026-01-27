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
      if (habit.streak > 0) habit.streak--;
    });
    _saveHabits();
  }

  void _addHabit(String name, bool isQuitting) {
    setState(() {
      _habits.add(Habit(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        isQuitting: isQuitting,
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

  void _showAddHabitDialog() {
    String name = '';
    bool isQuitting = false;

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
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: GestureDetector(
                      onTap: () {
                        if (name.trim().isNotEmpty) {
                          _addHabit(name.trim(), isQuitting);
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
