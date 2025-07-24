import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../models/training_method.dart';
import '../models/custom_workout.dart';
import '../utils/user_progress.dart';

class CustomWorkoutCreatorScreen extends StatefulWidget {
  const CustomWorkoutCreatorScreen({Key? key}) : super(key: key);

  @override
  State<CustomWorkoutCreatorScreen> createState() => _CustomWorkoutCreatorScreenState();
}

class _CustomWorkoutCreatorScreenState extends State<CustomWorkoutCreatorScreen> {
  final nameCtrl = TextEditingController();
  final Set<TrainingMethod> selectedMuscles = {};
  final List<String> exercises = [];
  final TextEditingController exerciseCtrl = TextEditingController();

  void _addExercise() {
    final text = exerciseCtrl.text.trim();
    if (text.isEmpty) return;
    setState(() {
      exercises.add(text);
      exerciseCtrl.clear();
    });
  }

  Future<void> _save() async {
    if (nameCtrl.text.trim().isEmpty || selectedMuscles.isEmpty || exercises.isEmpty) return;
    final workout = CustomWorkout(
      id: const Uuid().v4(),
      name: nameCtrl.text.trim(),
      muscles: selectedMuscles.map((e) => e.displayName).toList(),
      exercises: exercises,
    );
    await FirebaseFirestore.instance
        .collection('users')
        .doc('mockUser')
        .collection('customWorkouts')
        .doc(workout.id)
        .set(workout.toMap());

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Custom Workout')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Workout Name'),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: TrainingMethod.values.map((m) {
                final sel = selectedMuscles.contains(m);
                return FilterChip(
                  label: Text(m.displayName),
                  selected: sel,
                  onSelected: (_) {
                    setState(() {
                      sel ? selectedMuscles.remove(m) : selectedMuscles.add(m);
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: exerciseCtrl,
                    decoration: const InputDecoration(labelText: 'Exercise name'),
                  ),
                ),
                IconButton(icon: const Icon(Icons.add), onPressed: _addExercise),
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: exercises.length,
              itemBuilder: (c, i) => ListTile(title: Text(exercises[i])),
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: _save, child: const Text('Save Workout')),
          ],
        ),
      ),
    );
  }
} 