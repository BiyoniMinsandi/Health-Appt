// models/workout_plan.dart
class WorkoutPlan {
  final String id;
  final String title;
  final String duration;
  final String difficulty;
  final List<String> exercises;
  final String description;

  WorkoutPlan({
    required this.id,
    required this.title,
    required this.duration,
    required this.difficulty,
    required this.exercises,
    required this.description,
  });

  factory WorkoutPlan.fromJson(Map<String, dynamic> json) {
    return WorkoutPlan(
      id: json['id'],
      title: json['title'],
      duration: json['duration'],
      difficulty: json['difficulty'],
      exercises: List<String>.from(json['exercises']),
      description: json['description'],
    );
  }
}