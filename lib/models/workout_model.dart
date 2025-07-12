class SetEntry {
  final int reps;
  final double weight;

  SetEntry({required this.reps, required this.weight});

  Map<String, dynamic> toMap() => {
        'reps': reps,
        'weight': weight,
      };

  factory SetEntry.fromMap(Map<String, dynamic> map) => SetEntry(
        reps: map['reps'] as int,
        weight: (map['weight'] as num).toDouble(),
      );
}

class Workout {
  final String id;
  final String userId;
  final DateTime date;
  final String muscleGroup;
  final String exerciseName;
  final List<SetEntry> sets;
  final double volume;
  final double points;

  Workout({
    required this.id,
    required this.userId,
    required this.date,
    required this.muscleGroup,
    required this.exerciseName,
    required this.sets,
    required this.volume,
    required this.points,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'userId': userId,
        'date': date.toIso8601String(),
        'muscleGroup': muscleGroup,
        'exerciseName': exerciseName,
        'sets': sets.map((e) => e.toMap()).toList(),
        'volume': volume,
        'points': points,
      };

  factory Workout.fromMap(Map<String, dynamic> map) => Workout(
        id: map['id'] as String,
        userId: map['userId'] as String,
        date: DateTime.parse(map['date'] as String),
        muscleGroup: map['muscleGroup'] as String,
        exerciseName: map['exerciseName'] as String,
        sets: (map['sets'] as List)
            .map((e) => SetEntry.fromMap(Map<String, dynamic>.from(e)))
            .toList(),
        volume: (map['volume'] as num).toDouble(),
        points: (map['points'] as num).toDouble(),
      );
}

// ---------- New simplified models for UI layer ----------
class WorkoutSet {
  final int reps;
  final double weight;

  const WorkoutSet({required this.reps, required this.weight});

  double get volume => reps * weight;
}

class WorkoutEntry {
  final String category;
  final String exercise;
  final List<WorkoutSet> sets;

  const WorkoutEntry({
    required this.category,
    required this.exercise,
    required this.sets,
  });

  double get totalVolume =>
      sets.fold<double>(0, (sum, s) => sum + s.volume);
}

/// Temporary in-memory storage before real persistence is wired.
final List<WorkoutEntry> mockWorkoutEntries = []; 