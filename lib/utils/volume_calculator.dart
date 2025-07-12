import '../models/workout_model.dart';

class VolumeCalculator {
  static double calculateVolume(List<SetEntry> sets) {
    double volume = 0;
    for (final set in sets) {
      volume += set.reps * set.weight;
    }
    return volume;
  }

  static double calculatePoints(double volume) {
    if (volume < 1000) {
      return 0;
    } else if (volume < 5000) {
      return volume / 1000 * 1.0;
    } else if (volume < 10000) {
      return volume / 1000 * 0.8;
    } else if (volume < 20000) {
      return volume / 1000 * 0.5;
    } else {
      return volume / 1000 * 0.25;
    }
  }
} 