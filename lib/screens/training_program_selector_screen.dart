import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/training_program.dart';
import '../widgets/glass_carousel.dart';

class TrainingProgramSelectorScreen extends StatelessWidget {
  const TrainingProgramSelectorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final items = TrainingProgram.values
        .map((p) => CarouselItem(
              title: p.displayName,
              imageUrl: p.imageUrl,
              onTap: () => context.go('/muscles/${p.name}'),
            ))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Choose Training Method')),
      body: Center(
        child: GlassCarousel(items: items),
      ),
    );
  }
} 