import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  static const Color bg = Color(0xFF0A0A0A);
  static const Color cardBg = Color(0xFF161B22);
  static const Color accentGreen = Color(0xFF7DD3A8);
  static const Color danger = Color(0xFFF85149);
  static const Color textPrimary = Color(0xFFE6EDF3);
  static const Color textSecondary = Color(0xFF7D8590);

  static const _frenchDays = ['Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi', 'Dimanche'];
  static const _frenchMonths = ['janvier', 'février', 'mars', 'avril', 'mai', 'juin', 'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'];

  String get _formattedDate {
    final now = DateTime.now();
    return '${_frenchDays[now.weekday - 1]} ${now.day} ${_frenchMonths[now.month - 1]}';
  }

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
    _checkMissedDays();
  }

  void _checkMissedDays() {
    bool hasChanges = false;

    for (final habit in _habits) {
      if (habit.lastValidatedDate != null && habit.daysMissed > 0) {
        for (int i = 0; i < habit.daysMissed; i++) {
          _applyPenalty(habit);
        }
        hasChanges = true;
      }
    }

    if (hasChanges) {
      setState(() {});
      _saveHabits();
    }
  }

  void _applyPenalty(Habit habit) {
    switch (habit.penaltyMode) {
      case PenaltyMode.zen:
        if (habit.streak > 0) habit.streak--;
        break;
      case PenaltyMode.standard:
        int level = 1;
        int total = 0;
        while (total + level * level <= habit.streak) {
          total += level * level;
          level++;
        }
        if (habit.streak > total) {
          habit.streak = total;
        }
        break;
      case PenaltyMode.hardcore:
        habit.streak = 0;
        break;
    }
  }

  Future<void> _saveHabits() async {
    await _storageService.saveHabits(_habits);
  }

  void _incrementStreak(String id) {
    setState(() {
      final habit = _habits.firstWhere((h) => h.id == id);
      if (!habit.isValidatedToday) {
        habit.streak++;
        habit.lastValidatedDate = DateTime.now();
      }
    });
    _saveHabits();
  }

  void _decrementStreak(String id) {
    setState(() {
      final habit = _habits.firstWhere((h) => h.id == id);
      if (!habit.isValidatedToday) {
        _applyPenalty(habit);
        habit.lastValidatedDate = DateTime.now();
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
      backgroundColor: cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + MediaQuery.of(context).viewPadding.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nouvelle habitude',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    autofocus: true,
                    style: GoogleFonts.inter(color: textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Nom de l\'habitude',
                      hintStyle: GoogleFonts.inter(color: textSecondary),
                      filled: true,
                      fillColor: bg,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) => name = value,
                  ),
                  const SizedBox(height: 20),

                  // Type d'habitude
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setModalState(() => isQuitting = false),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: !isQuitting ? accentGreen.withValues(alpha: 0.2) : bg,
                              borderRadius: BorderRadius.circular(10),
                              border: !isQuitting ? Border.all(color: accentGreen.withValues(alpha: 0.4)) : null,
                            ),
                            child: Center(
                              child: Text('À faire', style: GoogleFonts.inter(
                                color: !isQuitting ? accentGreen : textSecondary,
                                fontWeight: FontWeight.w500,
                              )),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setModalState(() => isQuitting = true),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: isQuitting ? danger.withValues(alpha: 0.2) : bg,
                              borderRadius: BorderRadius.circular(10),
                              border: isQuitting ? Border.all(color: danger.withValues(alpha: 0.4)) : null,
                            ),
                            child: Center(
                              child: Text('À arrêter', style: GoogleFonts.inter(
                                color: isQuitting ? danger : textSecondary,
                                fontWeight: FontWeight.w500,
                              )),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Mode de pénalité
                  Text(
                    'Mode de pénalité',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: textSecondary,
                    ),
                  ),
                  const SizedBox(height: 10),
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
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: textSecondary.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 24),

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
                          color: accentGreen,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'Créer',
                            style: GoogleFonts.inter(
                              color: const Color(0xFF0A0A0A),
                              fontWeight: FontWeight.w600,
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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? textPrimary.withValues(alpha: 0.1) : bg,
            borderRadius: BorderRadius.circular(10),
            border: isSelected ? Border.all(color: textPrimary.withValues(alpha: 0.2)) : null,
          ),
          child: Column(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 4),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                  color: isSelected ? textPrimary : textSecondary,
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
      floatingActionButton: FloatingActionButton.small(
        onPressed: _showAddHabitDialog,
        backgroundColor: accentGreen,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(Icons.add, color: Color(0xFF0A0A0A), size: 22),
      ),
      body: SafeArea(
        child: _isLoading
          ? const Center(child: CircularProgressIndicator(color: accentGreen))
          : Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.ideographic,
                          children: [
                            Text(
                              '元',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w300,
                                color: textPrimary.withValues(alpha: 0.2),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Moto',
                              style: GoogleFonts.inter(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formattedDate,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: textSecondary,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Icon(
                      Icons.settings_outlined,
                      color: textSecondary.withValues(alpha: 0.5),
                      size: 22,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 36),

              // Liste des habitudes
              Expanded(
                child: _habits.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.grid_view_rounded,
                            size: 48,
                            color: textSecondary.withValues(alpha: 0.25),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Aucune habitude',
                            style: GoogleFonts.inter(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: textSecondary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Commence à construire ta base',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: textSecondary.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewPadding.bottom + 80,
                      ),
                      itemCount: _habits.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 14),
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
