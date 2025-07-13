import 'package:flutter/material.dart';
import '../models/workout_model.dart';
import '../utils/volume_calculator.dart';
import '../services/mock_firestore.dart';
import '../utils/user_progress.dart';
import '../utils/smart_feedback.dart';

class WorkoutLogScreen extends StatefulWidget {
  final String exercise;
  const WorkoutLogScreen({Key? key, required this.exercise}) : super(key: key);

  @override
  State<WorkoutLogScreen> createState() => _WorkoutLogScreenState();
}

class _WorkoutLogScreenState extends State<WorkoutLogScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _repsControllers = [];
  final List<TextEditingController> _weightControllers = [];

  @override
  void initState() {
    super.initState();
    _addSet(); // start with one set
  }

  void _addSet() {
    setState(() {
      _repsControllers.add(TextEditingController());
      _weightControllers.add(TextEditingController());
    });
  }

  List<WorkoutSet> _collectSets() {
    final workoutSets = <WorkoutSet>[];
    for (var i = 0; i < _repsControllers.length; i++) {
      final repsText = _repsControllers[i].text;
      final weightText = _weightControllers[i].text;
      if (repsText.isEmpty || weightText.isEmpty) continue;
      final reps = int.tryParse(repsText) ?? 0;
      final weight = double.tryParse(weightText) ?? 0;
      if (reps > 0 && weight > 0) {
        workoutSets.add(WorkoutSet(reps: reps, weight: weight));
      }
    }
    return workoutSets;
  }

  String _feedback(double volume) {
    if (volume > 3000) return '🔥 Great effort!';
    if (volume > 1500) return '👍 Good job';
    return '💪 Push harder next time';
  }

  Future<void> _saveWorkoutAndExit({required bool endWorkout}) async {
    if (!_formKey.currentState!.validate()) return;

    final workoutSets = _collectSets();
    if (workoutSets.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Add at least one set.')));
      return;
    }

    // Build WorkoutEntry to compute volume
    final entry = WorkoutEntry(
      category: widget.exercise,
      exercise: widget.exercise,
      sets: workoutSets,
      date: DateTime.now(),
    );

    // Store in mock history
    UserProgress.workoutHistory.add(entry);

    // Smart feedback
    final aiFeedback = SmartFeedback.generateFeedback(UserProgress.workoutHistory);

    final double volume = entry.totalVolume;

    // Points earned based on volume (floor(volume / 1000))
    final int pointsEarned = (volume / 1000).floor();
    UserProgress.totalPoints += pointsEarned;
    final String feedback = _feedback(volume);

    // Save to mock firestore using legacy model for consistency
    final workout = Workout(
      id: '',
      userId: 'mockUser',
      date: DateTime.now(),
      muscleGroup: 'Unknown',
      exerciseName: widget.exercise,
      sets: workoutSets
          .map((w) => SetEntry(reps: w.reps, weight: w.weight))
          .toList(),
      volume: volume,
      points: pointsEarned.toDouble(),
    );
    await MockFirestore.instance.saveWorkout(workout);

    if (endWorkout) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Workout Summary'),
          content: Text(
              'Volume: ${volume.toStringAsFixed(0)}\n$feedback\nAI: $aiFeedback\nPoints Earned: $pointsEarned'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      Navigator.popUntil(context, ModalRoute.withName('/home'));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$feedback Volume: ${volume.toStringAsFixed(0)}')),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    for (final c in _repsControllers) {
      c.dispose();
    }
    for (final c in _weightControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Log ${widget.exercise}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: _repsControllers.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _repsControllers[index],
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Reps',
                                border: OutlineInputBorder(),
                              ),
                              validator: (v) {
                                if (v == null || v.isEmpty) return 'Enter reps';
                                if (int.tryParse(v) == null) return 'Invalid';
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _weightControllers[index],
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              decoration: const InputDecoration(
                                labelText: 'Weight',
                                border: OutlineInputBorder(),
                              ),
                              validator: (v) {
                                if (v == null || v.isEmpty) return 'Enter weight';
                                if (double.tryParse(v) == null) return 'Invalid';
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: _addSet,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Set'),
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () => _saveWorkoutAndExit(endWorkout: false),
                        child: const Text('✅ Done'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () => _saveWorkoutAndExit(endWorkout: true),
                        child: const Text('🏁 End Workout'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
} 