// models/health_tip.dart

class HealthTip {
  final String title;
  final String description;
  final String category;
  final String icon;

  HealthTip({
    required this.title,
    required this.description,
    required this.category,
    required this.icon,
  });

  factory HealthTip.fromJson(Map<String, dynamic> json) {
    return HealthTip(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      icon: json['icon'] ?? '',
    );
  }
}