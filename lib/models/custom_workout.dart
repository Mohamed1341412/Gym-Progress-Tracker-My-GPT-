import 'package:cloud_firestore/cloud_firestore.dart';

class CustomWorkout {
  String id;
  String name;
  List<String> muscles; // display names
  List<String> exercises;

  CustomWorkout({
    required this.id,
    required this.name,
    required this.muscles,
    required this.exercises,
  });

  Map<String, dynamic> toMap() => {
        'name': name,
        'muscles': muscles,
        'exercises': exercises,
      };

  factory CustomWorkout.fromDoc(DocumentSnapshot doc) => CustomWorkout(
        id: doc.id,
        name: doc['name'],
        muscles: List<String>.from(doc['muscles']),
        exercises: List<String>.from(doc['exercises']),
      );
} 