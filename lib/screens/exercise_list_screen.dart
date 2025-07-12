import 'package:flutter/material.dart';

class ExerciseListScreen extends StatelessWidget {
  final String category;
  const ExerciseListScreen({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$category Exercises')),
      body: Center(
        child: Text('Exercises for $category coming soon...'),
      ),
    );
  }
} 