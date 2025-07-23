import 'package:flutter/material.dart';
import '../models/training_method.dart';
import 'package:go_router/go_router.dart';

class ExerciseListScreen extends StatefulWidget {
  final TrainingMethod method;
  const ExerciseListScreen({Key? key, required this.method}) : super(key: key);

  @override
  State<ExerciseListScreen> createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends State<ExerciseListScreen> {
  late List<String> _exercises;

  static const Map<String, List<String>> _defaultExercises = {
    'Push': ['Bench Press', 'Overhead Press', 'Tricep Dips'],
    'Pull': ['Pull Ups', 'Barbell Row', 'Bicep Curl'],
    'Legs': ['Squat', 'Deadlift', 'Lunges'],
    'Chest': ['Flat Bench', 'Incline Dumbbell', 'Cable Fly'],
    'Back': ['Lat Pulldown', 'Seated Row', 'Good Morning'],
    'Shoulders': ['Military Press', 'Lateral Raise', 'Face Pull'],
    'Arms': ['Bicep Curl', 'Tricep Pushdown', 'Hammer Curl'],
  };

  @override
  void initState() {
    super.initState();
    _exercises = List<String>.from(
        _defaultExercises[widget.method.displayName] ?? const <String>[]);
  }

  void _addExercise() async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Custom Exercise'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Exercise name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final text = controller.text.trim();
              if (text.isNotEmpty) Navigator.pop(context, text);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
    if (result != null) {
      setState(() {
        _exercises.add(result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.method.displayName} Exercises')),
      floatingActionButton: FloatingActionButton(
        onPressed: _addExercise,
        child: const Icon(Icons.add),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(8),
        itemBuilder: (context, index) {
          final exercise = _exercises[index];
          return ListTile(
            title: Text(exercise),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              context.push('/workoutLog/$exercise');
            },
          );
        },
        separatorBuilder: (context, index) => const Divider(),
        itemCount: _exercises.length,
      ),
    );
  }
} 