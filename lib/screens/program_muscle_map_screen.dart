import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/training_program.dart';
import '../models/training_method.dart';
import '../widgets/glass_carousel.dart';

class ProgramMuscleMapScreen extends StatelessWidget {
  final TrainingProgram program;
  const ProgramMuscleMapScreen({Key? key, required this.program}) : super(key: key);

  List<TrainingMethod> _methodsForProgram() {
    switch (program) {
      case TrainingProgram.ppl:
        return [TrainingMethod.push, TrainingMethod.pull, TrainingMethod.legs];
      case TrainingProgram.proSplit:
        return [
          TrainingMethod.chest,
          TrainingMethod.back,
          TrainingMethod.shoulders,
          TrainingMethod.arms,
          TrainingMethod.legs,
          TrainingMethod.forearms,
          TrainingMethod.wrists,
        ];
      case TrainingProgram.custom:
        return TrainingMethod.values;
    }
  }

  @override
  Widget build(BuildContext context) {
    final methods = _methodsForProgram();

    final items = methods
        .map((m) => CarouselItem(
              title: m.displayName,
              imageUrl: 'https://via.placeholder.com/400x300?text=${m.displayName}',
              onTap: () => context.push('/exercise/${m.displayName}'),
            ))
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text('${program.displayName} - Choose Muscle')),
      body: GlassCarousel(items: items),
    );
  }
} 