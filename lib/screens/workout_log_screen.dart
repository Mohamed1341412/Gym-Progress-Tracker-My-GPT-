import 'package:flutter/material.dart';
import '../models/workout_model.dart';
import '../utils/volume_calculator.dart';
import '../services/mock_firestore.dart';

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

  List<SetEntry> _collectSets() {
    final sets = <SetEntry>[];
    for (var i = 0; i < _repsControllers.length; i++) {
      final repsText = _repsControllers[i].text;
      final weightText = _weightControllers[i].text;
      if (repsText.isEmpty || weightText.isEmpty) continue;
      final reps = int.tryParse(repsText) ?? 0;
      final weight = double.tryParse(weightText) ?? 0;
      if (reps > 0 && weight > 0) {
        sets.add(SetEntry(reps: reps, weight: weight));
      }
    }
    return sets;
  }

  String _feedback(double volume) {
    if (volume > 3000) return '🔥 Great effort!';
    if (volume > 1500) return '👍 Good job';
    return '💪 Push harder next time';
  }

  Future<void> _saveWorkoutAndExit({required bool endWorkout}) async {
    if (!_formKey.currentState!.validate()) return;

    final sets = _collectSets();
    if (sets.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Add at least one set.')));
      return;
    }

    final volume = VolumeCalculator.calculateVolume(sets);
    final points = VolumeCalculator.calculatePoints(volume);

    // Save to mock firestore
    final workout = Workout(
      id: '',
      userId: 'mockUser',
      date: DateTime.now(),
      muscleGroup: 'Unknown',
      exerciseName: widget.exercise,
      sets: sets,
      volume: volume,
      points: points,
    );
    await MockFirestore.instance.saveWorkout(workout);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${_feedback(volume)} Volume: ${volume.toStringAsFixed(0)}')),
    );

    if (endWorkout) {
      Navigator.popUntil(context, ModalRoute.withName('/home'));
    } else {
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