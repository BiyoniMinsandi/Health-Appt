// screens/patient/chat_list_screen.dart
import 'package:flutter/material.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatelessWidget {
  final List<Map<String, dynamic>> _mockContacts = [
    {
      'id': 'doctor1',
      'name': 'Dr. Smith',
      'type': 'Doctor',
      'specialization': 'Cardiologist',
      'lastMessage': 'How are your blood pressure readings?',
      'timestamp': '2 hours ago',
      'unread': 1,
    },
    {
      'id': 'doctor2',
      'name': 'Dr. Johnson',
      'type': 'Doctor',
      'specialization': 'General Physician',
      'lastMessage': 'Please schedule your next checkup',
      'timestamp': '1 day ago',
      'unread': 0,
    },
    {
      'id': 'hospital1',
      'name': 'City General Hospital',
      'type': 'Hospital',
      'specialization': 'Emergency Services',
      'lastMessage': 'Your test results are ready',
      'timestamp': '3 days ago',
      'unread': 0,
    },
    {
      'id': 'caregiver1',
      'name': 'Nurse Mary',
      'type': 'Caregiver',
      'specialization': 'Home Care',
      'lastMessage': 'Medication reminder set for tomorrow',
      'timestamp': '5 days ago',
      'unread': 0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Messages',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Connect with your healthcare providers',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _mockContacts.length,
              itemBuilder: (context, index) {
                final contact = _mockContacts[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getColorForType(contact['type']),
                      child: Icon(
                        _getIconForType(contact['type']),
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      contact['name'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          contact['specialization'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.teal[600],
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          contact['lastMessage'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          contact['timestamp'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        if (contact['unread'] > 0) ...[
                          SizedBox(height: 4),
                          CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.red,
                            child: Text(
                              '${contact['unread']}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            contactId: contact['id'],
                            contactName: contact['name'],
                            contactType: contact['type'],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showNewChatDialog(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.teal[600],
      ),
    );
  }

  Color _getColorForType(String type) {
    switch (type.toLowerCase()) {
      case 'doctor':
        return Colors.blue;
      case 'hospital':
        return Colors.red;
      case 'caregiver':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getIconForType(String type) {
    switch (type.toLowerCase()) {
      case 'doctor':
        return Icons.medical_services;
      case 'hospital':
        return Icons.local_hospital;
      case 'caregiver':
        return Icons.health_and_safety;
      default:
        return Icons.person;
    }
  }

  void _showNewChatDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Start New Chat'),
        content: Text('Feature coming soon! You\'ll be able to connect with new healthcare providers.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}