// screens/patient/medication_reminders_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MedicationReminder {
  final String id;
  final String medicationName;
  final String dosage;
  final TimeOfDay time;
  final List<int> days; // 1-7 for Mon-Sun
  final bool isActive;

  MedicationReminder({
    required this.id,
    required this.medicationName,
    required this.dosage,
    required this.time,
    required this.days,
    this.isActive = true,
  });
}

class MedicationRemindersScreen extends StatefulWidget {
  @override
  _MedicationRemindersScreenState createState() => _MedicationRemindersScreenState();
}

class _MedicationRemindersScreenState extends State<MedicationRemindersScreen> {
  List<MedicationReminder> _reminders = [
    MedicationReminder(
      id: '1',
      medicationName: 'Metformin',
      dosage: '500mg',
      time: TimeOfDay(hour: 8, minute: 0),
      days: [1, 2, 3, 4, 5, 6, 7],
    ),
    MedicationReminder(
      id: '2',
      medicationName: 'Lisinopril',
      dosage: '10mg',
      time: TimeOfDay(hour: 20, minute: 0),
      days: [1, 2, 3, 4, 5, 6, 7],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medication Reminders'),
        backgroundColor: Colors.teal[600],
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: _reminders.length,
        itemBuilder: (context, index) {
          final reminder = _reminders[index];
          return Card(
            margin: EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              reminder.medicationName,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Dosage: ${reminder.dosage}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: reminder.isActive,
                        onChanged: (value) {
                          setState(() {
                            // Toggle reminder active state
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                      SizedBox(width: 4),
                      Text(
                        '${reminder.time.format(context)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Days: ${_getDaysText(reminder.days)}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => _editReminder(reminder),
                        child: Text('Edit'),
                      ),
                      TextButton(
                        onPressed: () => _deleteReminder(reminder.id),
                        child: Text('Delete'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addReminder,
        backgroundColor: Colors.teal[600],
        child: Icon(Icons.add),
      ),
    );
  }

  String _getDaysText(List<int> days) {
    const dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    if (days.length == 7) return 'Every day';
    return days.map((day) => dayNames[day - 1]).join(', ');
  }

  void _editReminder(MedicationReminder reminder) {
    // Navigate to edit reminder screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit reminder feature coming soon!')),
    );
  }

  void _deleteReminder(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Reminder'),
        content: Text('Are you sure you want to delete this medication reminder?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _reminders.removeWhere((r) => r.id == id);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Reminder deleted')),
              );
            },
            child: Text('Delete'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      ),
    );
  }

  void _addReminder() {
    // Navigate to add reminder screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Add reminder feature coming soon!')),
    );
  }
}