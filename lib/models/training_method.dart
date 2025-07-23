import 'package:flutter/material.dart';

enum TrainingMethod {
  push,
  pull,
  legs,
  chest,
  back,
  shoulders,
  arms,
  abs,
  pushUps,
  pullUps,
  planks,
  cardio,
}

extension TrainingMethodX on TrainingMethod {
  String get displayName {
    switch (this) {
      case TrainingMethod.push:
        return 'Push';
      case TrainingMethod.pull:
        return 'Pull';
      case TrainingMethod.legs:
        return 'Legs';
      case TrainingMethod.chest:
        return 'Chest';
      case TrainingMethod.back:
        return 'Back';
      case TrainingMethod.shoulders:
        return 'Shoulders';
      case TrainingMethod.arms:
        return 'Arms';
      case TrainingMethod.abs:
        return 'Abs';
      case TrainingMethod.pushUps:
        return 'Push-Ups';
      case TrainingMethod.pullUps:
        return 'Pull-Ups';
      case TrainingMethod.planks:
        return 'Planks';
      case TrainingMethod.cardio:
        return 'Cardio';
    }
  }

  IconData get icon {
    switch (this) {
      case TrainingMethod.push:
        return Icons.push_pin;
      case TrainingMethod.pull:
        return Icons.anchor;
      case TrainingMethod.legs:
        return Icons.directions_run;
      case TrainingMethod.chest:
        return Icons.fitness_center;
      case TrainingMethod.back:
        return Icons.back_hand;
      case TrainingMethod.shoulders:
        return Icons.accessibility_new;
      case TrainingMethod.arms:
        return Icons.pan_tool;
      case TrainingMethod.abs:
        return Icons.crop_square;
      case TrainingMethod.pushUps:
        return Icons.push_pin_outlined;
      case TrainingMethod.pullUps:
        return Icons.arrow_circle_up;
      case TrainingMethod.planks:
        return Icons.horizontal_rule;
      case TrainingMethod.cardio:
        return Icons.directions_bike;
    }
  }
} 