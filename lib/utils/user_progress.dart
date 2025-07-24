import '../models/workout_model.dart';
import 'package:flutter/foundation.dart';

class UserProgress {
  static int totalPoints = 0;
  static List<WorkoutEntry> workoutHistory = [];
  static ValueNotifier<String?> latestFeedback = ValueNotifier(null);
} 