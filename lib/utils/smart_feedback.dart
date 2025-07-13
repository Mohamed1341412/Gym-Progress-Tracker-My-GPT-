import 'package:intl/intl.dart';

import '../models/workout_model.dart';

class SmartFeedback {
  /// Generates a user-friendly feedback string analyzing [history].
  ///
  /// Assumptions:
  /// • Each [WorkoutEntry] has a [date] in its local time.
  /// • [history] may contain workouts for multiple categories.
  ///   The list need not be sorted; we sort internally by date descending.
  static String generateFeedback(List<WorkoutEntry> history) {
    if (history.isEmpty) return 'Let\'s start logging some workouts!';

    // Sort newest first
    final sorted = List<WorkoutEntry>.from(history)
      ..sort((a, b) => b.date.compareTo(a.date));

    // Group by category
    final Map<String, List<WorkoutEntry>> byCat = {};
    for (final w in sorted) {
      byCat.putIfAbsent(w.category, () => []).add(w);
    }

    // 1. Check stale muscle groups first (no workout in last 7 days)
    const int staleDays = 7;
    final now = DateTime.now();
    for (final cat in byCat.keys) {
      final last = byCat[cat]!.first;
      final days = now.difference(last.date).inDays;
      if (days >= staleDays) {
        return "It's been $days days since your last $cat workout. Don't skip $cat day 🦵";
      }
    }

    // 2. Look for volume increase / decrease comparing last 2 sessions of same category
    for (final cat in byCat.keys) {
      final entries = byCat[cat]!;
      if (entries.length < 2) continue;
      final last = entries[0];
      final prev = entries[1];
      final diff = last.totalVolume - prev.totalVolume;
      final pct = (diff / prev.totalVolume) * 100;
      if (pct.abs() < 5) continue; // ignore tiny changes
      if (pct > 0) {
        return 'Your $cat training volume is up by ${pct.toStringAsFixed(0)}% — nice progress!';
      } else {
        return 'Your $cat volume dropped by ${pct.abs().toStringAsFixed(0)}%. Try to match last session's effort.';
      }
    }

    // 3. Default motivational message based on last workout
    final last = sorted.first;
    final fmt = DateFormat('MMM d');
    return 'Great job on your ${last.category} workout on ${fmt.format(last.date)}! Keep it up!';
  }
} 