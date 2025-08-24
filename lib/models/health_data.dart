// models/health_data.dart
class HealthData {
  final String id;
  final String patientId;
  final String dataType;
  final double value;
  final String unit;
  final DateTime timestamp;
  final String? notes;

  HealthData({
    required this.id,
    required this.patientId,
    required this.dataType,
    required this.value,
    required this.unit,
    required this.timestamp,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'dataType': dataType,
      'value': value,
      'unit': unit,
      'timestamp': timestamp.toIso8601String(),
      'notes': notes,
    };
  }

  factory HealthData.fromJson(Map<String, dynamic> json) {
    return HealthData(
      id: json['id'],
      patientId: json['patientId'],
      dataType: json['dataType'],
      value: json['value'].toDouble(),
      unit: json['unit'],
      timestamp: DateTime.parse(json['timestamp']),
      notes: json['notes'],
    );
  }
}