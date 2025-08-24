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

// models/health_tip.dart
class HealthTip {
  final String id;
  final String title;
  final String description;
  final String category;
  final String icon;

  HealthTip({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.icon,
  });

  factory HealthTip.fromJson(Map<String, dynamic> json) {
    return HealthTip(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      icon: json['icon'],
    );
  }
}