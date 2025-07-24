import 'package:flutter/material.dart';
import '../models/training_method.dart';
import 'package:go_router/go_router.dart';
import '../widgets/glass_carousel.dart';

class ExerciseListScreen extends StatefulWidget {
  final TrainingMethod method;
  const ExerciseListScreen({Key? key, required this.method}) : super(key: key);

  @override
  State<ExerciseListScreen> createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends State<ExerciseListScreen> {
  late List<String> _exercises;
  final TextEditingController _searchCtrl = TextEditingController();

  static const Map<String, List<String>> _defaultExercises = {
    'Push': ['Bench Press', 'Overhead Press', 'Tricep Dips', 'Wrist Curl', 'Reverse Wrist Curl'],
    'Pull': ['Pull Ups', 'Barbell Row', 'Bicep Curl', 'Forearm Curl', 'Reverse Forearm Curl'],
    'Legs': ['Squat', 'Deadlift', 'Lunges'],
    'Chest': ['Flat Bench', 'Incline Dumbbell', 'Cable Fly'],
    'Back': ['Lat Pulldown', 'Seated Row', 'Good Morning'],
    'Shoulders': ['Military Press', 'Lateral Raise', 'Face Pull'],
    'Arms': ['Bicep Curl', 'Tricep Pushdown', 'Hammer Curl', 'Wrist Curl', 'Forearm Curl'],
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchCtrl,
              decoration: const InputDecoration(
                hintText: 'Search exercise',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          Expanded(
            child: GlassCarousel(
              items: _exercises
                  .where((e) => e.toLowerCase().contains(_searchCtrl.text.toLowerCase()))
                  .map((name) => CarouselItem(
                      title: name,
                      imageUrl: 'https://via.placeholder.com/400x300?text=$name',
                      onTap: () => context.push('/workoutLog/$name')))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
  @override
  void dispose(){
    _searchCtrl.dispose();
    super.dispose();
  }
} 