import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/training_method.dart';
import '../models/workout_model.dart';
import '../utils/user_progress.dart';

class BodyweightAndCardioScreen extends StatefulWidget {
  const BodyweightAndCardioScreen({Key? key}) : super(key: key);

  @override
  State<BodyweightAndCardioScreen> createState() => _BodyweightAndCardioScreenState();
}

class _BodyweightAndCardioScreenState extends State<BodyweightAndCardioScreen> {
  TrainingMethod? _selected;

  final repsCtrl = TextEditingController();
  final setsCtrl = TextEditingController();
  final durationCtrl = TextEditingController();
  final distanceCtrl = TextEditingController();
  final caloriesCtrl = TextEditingController();
  final hrCtrl = TextEditingController();

  void _save() {
    if (_selected == null) return;

    final sets = int.tryParse(setsCtrl.text) ?? 0;
    final reps = int.tryParse(repsCtrl.text) ?? 0;
    final durationMin = double.tryParse(durationCtrl.text) ?? 0;

    double volume = 0;
    int points = 0;

    switch (_selected) {
      case TrainingMethod.abs:
      case TrainingMethod.pushUps:
      case TrainingMethod.pullUps:
      case TrainingMethod.forearms:
      case TrainingMethod.wrists:
        volume = sets * reps;
        if (_selected == TrainingMethod.pushUps) {
          points = (reps * sets / 30).floor();
        } else if (_selected == TrainingMethod.pullUps) {
          points = (reps * sets / 10).floor();
        } else {
          points = (volume / 1000).floor();
        }
        break;
      case TrainingMethod.planks:
        points = (durationMin * 0.5).floor();
        break;
      case TrainingMethod.cardio:
        points = (durationMin / 5).floor();
        break;
      default:
        volume = sets * reps;
        points = (volume / 1000).floor();
    }

    final entry = WorkoutEntry(
      category: _selected!.displayName,
      exercise: _selected!.displayName,
      sets: [WorkoutSet(reps: reps, weight: 0)],
      date: DateTime.now(),
    );
    UserProgress.workoutHistory.add(entry);
    UserProgress.totalPoints += points;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Logged! Points earned: $points')),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final categories = [
      TrainingMethod.abs,
      TrainingMethod.pushUps,
      TrainingMethod.pullUps,
      TrainingMethod.planks,
      TrainingMethod.forearms,
      TrainingMethod.wrists,
      TrainingMethod.cardio,
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Bodyweight & Cardio')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: categories.map((e) {
                final selected = e == _selected;
                return ChoiceChip(
                  label: Text(e.displayName),
                  selected: selected,
                  onSelected: (_) => setState(() => _selected = e),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            if (_selected != null) _buildForm(),
            const Spacer(),
            ElevatedButton(
              onPressed: _save,
              child: const Text('Save Workout'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    switch (_selected) {
      case TrainingMethod.planks:
        return TextField(
          controller: durationCtrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Duration (minutes)'),
        );
      case TrainingMethod.cardio:
        return Column(
          children: [
            TextField(
              controller: durationCtrl,
              decoration: const InputDecoration(labelText: 'Duration (minutes)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: distanceCtrl,
              decoration: const InputDecoration(labelText: 'Distance (km) optional'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: caloriesCtrl,
              decoration: const InputDecoration(labelText: 'Calories burned optional'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: hrCtrl,
              decoration: const InputDecoration(labelText: 'Avg Heart Rate optional'),
              keyboardType: TextInputType.number,
            ),
          ],
        );
      default:
        return Column(
          children: [
            TextField(
              controller: setsCtrl,
              decoration: const InputDecoration(labelText: 'Sets'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: repsCtrl,
              decoration: const InputDecoration(labelText: 'Reps per set'),
              keyboardType: TextInputType.number,
            ),
          ],
        );
    }
  }
} 