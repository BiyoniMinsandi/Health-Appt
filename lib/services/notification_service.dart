// services/notification_service.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static BuildContext? _context;

  static void setContext(BuildContext context) {
    _context = context;
  }

  Future<void> initialize() async {
    // Initialize notification plugin
    // Implementation would depend on flutter_local_notifications package
    debugPrint('Notification service initialized');
  }

  Future<void> scheduleHealthReminder(String title, String body, DateTime scheduledDate) async {
    // Schedule notification for health data entry reminders
    debugPrint('Health reminder scheduled: $title at $scheduledDate');
    
    // For demo purposes, show a snackbar
    if (_context != null) {
      ScaffoldMessenger.of(_context!).showSnackBar(
        SnackBar(
          content: Text('Health reminder scheduled: $title'),
          backgroundColor: Colors.teal[600],
        ),
      );
    }
  }

  Future<void> showMedicationReminder(String medicationName, String dosage) async {
    // Show medication reminder notification
    debugPrint('Medication reminder: $medicationName - $dosage');
    
    // For demo purposes, show a snackbar
    if (_context != null) {
      ScaffoldMessenger.of(_context!).showSnackBar(
        SnackBar(
          content: Text('Time to take $medicationName ($dosage)'),
          backgroundColor: Colors.orange[600],
          action: SnackBarAction(
            label: 'TAKEN',
            textColor: Colors.white,
            onPressed: () {
              debugPrint('Medication marked as taken');
            },
          ),
        ),
      );
    }
  }

  Future<void> showHealthAlert(String title, String message, {bool isUrgent = false}) async {
    // Show health alert notification
    debugPrint('Health alert: $title - $message');
    
    if (_context != null) {
      final color = isUrgent ? Colors.red : Colors.orange;
      ScaffoldMessenger.of(_context!).showSnackBar(
        SnackBar(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
              Text(message),
            ],
          ),
          backgroundColor: color,
          duration: Duration(seconds: isUrgent ? 10 : 5),
        ),
      );
    }
  }

  Future<void> showAchievementNotification(String achievement) async {
    // Show achievement notification
    debugPrint('Achievement unlocked: $achievement');
    
    if (_context != null) {
      ScaffoldMessenger.of(_context!).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.star, color: Colors.white),
              SizedBox(width: 8),
              Expanded(child: Text('Achievement: $achievement')),
            ],
          ),
          backgroundColor: Colors.green[600],
        ),
      );
    }
  }
}