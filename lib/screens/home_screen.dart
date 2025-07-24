import '../models/training_method.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static final _methods = [
    TrainingMethod.push,
    TrainingMethod.pull,
    TrainingMethod.legs,
    TrainingMethod.chest,
    TrainingMethod.back,
    TrainingMethod.shoulders,
    TrainingMethod.arms,
    TrainingMethod.abs,
    TrainingMethod.cardio,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose a Category'),
        actions: [
          IconButton(
            icon: const Icon(Icons.smart_toy),
            onPressed: () => Navigator.pushNamed(context, '/aiChat'),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.indigo],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.0,
          ),
          itemCount: _methods.length,
          itemBuilder: (context, index) {
            final method = _methods[index];
            return _CategoryCard(
              method: method,
              onTap: () {
                context.push('/exercise/${method.name}');
              },
            );
          },
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: ElevatedButton.icon(
          onPressed: () => context.push('/bodyweight'),
          icon: const Icon(Icons.accessibility_new),
          label: const Text('Bodyweight & Cardio'),
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final TrainingMethod method;
  final VoidCallback onTap;
  const _CategoryCard({Key? key, required this.method, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [Colors.white, Colors.blueGrey],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(method.icon, size: 48, color: Colors.indigo),
              const SizedBox(height: 12),
              Text(
                method.displayName,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 