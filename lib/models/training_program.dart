enum TrainingProgram { ppl, proSplit, custom }

extension TrainingProgramX on TrainingProgram {
  String get displayName {
    switch (this) {
      case TrainingProgram.ppl:
        return 'PPL';
      case TrainingProgram.proSplit:
        return 'Pro Split';
      case TrainingProgram.custom:
        return 'Custom';
    }
  }

  String get imageUrl {
    switch (this) {
      case TrainingProgram.ppl:
        return 'https://i.imgur.com/n5uY2bV.jpg';
      case TrainingProgram.proSplit:
        return 'https://i.imgur.com/JtZHFb7.jpg';
      case TrainingProgram.custom:
        return 'https://i.imgur.com/0X0X0X0.jpg';
    }
  }
} 