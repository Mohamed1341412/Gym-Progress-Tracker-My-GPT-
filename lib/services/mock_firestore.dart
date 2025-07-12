import 'dart:async';
import 'package:uuid/uuid.dart';

import '../models/workout_model.dart';

/// A lightweight in-memory mock of the subset of Firebase Firestore functionality
/// needed by the app before real Firebase is available.
///
/// It supports:
/// • Adding a workout (generates a UUID if not provided)
/// • Fetching all workouts for the current user
/// • Streaming live updates as workouts are added/modified
class MockFirestore {
  MockFirestore._internal();
  static final MockFirestore instance = MockFirestore._internal();

  final _uuid = const Uuid();

  // _workouts maps workoutId → Workout
  final Map<String, Workout> _workouts = {};

  final StreamController<List<Workout>> _workoutStreamController =
      StreamController<List<Workout>>.broadcast();

  /// Returns a broadcast stream of all workouts belonging to [userId].
  Stream<List<Workout>> workoutsStream({required String userId}) {
    return _workoutStreamController.stream.map((all) =>
        all.where((w) => w.userId == userId).toList());
  }

  /// Adds or overwrites a workout.
  Future<void> saveWorkout(Workout workout) async {
    // Ensure the workout has an ID
    final id = workout.id.isEmpty ? _uuid.v4() : workout.id;
    final toSave = Workout(
      id: id,
      userId: workout.userId,
      date: workout.date,
      muscleGroup: workout.muscleGroup,
      exerciseName: workout.exerciseName,
      sets: workout.sets,
      volume: workout.volume,
      points: workout.points,
    );

    _workouts[id] = toSave;

    // Notify listeners
    _workoutStreamController.add(_workouts.values.toList());
  }

  /// Fetches all workouts for [userId].
  Future<List<Workout>> fetchWorkouts({required String userId}) async {
    return _workouts.values.where((w) => w.userId == userId).toList();
  }

  /// Clears all stored data – helpful for tests.
  Future<void> clear() async {
    _workouts.clear();
    _workoutStreamController.add([]);
  }

  void dispose() {
    _workoutStreamController.close();
  }
} 