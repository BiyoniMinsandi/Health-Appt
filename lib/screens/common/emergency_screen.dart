// screens/common/emergency_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class EmergencyScreen extends StatelessWidget {
  final List<Map<String, dynamic>> _emergencyContacts = [
    {
      'name': 'Emergency Services',
      'number': '911',
      'icon': Icons.local_hospital,
      'color': Colors.red,
      'description': 'Call for immediate emergency assistance',
    },
    {
      'name': 'Poison Control',
      'number': '1-800-222-1222',
      'icon': Icons.warning,
      'color': Colors.orange,
      'description': 'Poison control center hotline',
    },
    {
      'name': 'Mental Health Crisis',
      'number': '988',
      'icon': Icons.psychology,
      'color': Colors.purple,
      'description': '24/7 mental health crisis support',
    },
    {
      'name': 'Primary Doctor',
      'number': '+1 (555) 123-4567',
      'icon': Icons.medical_services,
      'color': Colors.blue,
      'description': 'Your assigned primary care physician',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.red[50],
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.emergency,
                      size: 40,
                      color: Colors.red,
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Emergency Services',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.red[800],
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Quick access to emergency contacts and services',
                            style: TextStyle(color: Colors.red[700]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Emergency Contacts',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _emergencyContacts.length,
              itemBuilder: (context, index) {
                final contact = _emergencyContacts[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: contact['color'],
                      child: Icon(
                        contact['icon'],
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
                          contact['number'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: contact['color'],
                          ),
                        ),
                        Text(
                          contact['description'],
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.phone, color: contact['color']),
                      onPressed: () {
                        _makeEmergencyCall(context, contact);
                      },
                    ),
                    onTap: () {
                      _makeEmergencyCall(context, contact);
                    },
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Emergency Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, child) {
                        return Column(
                          children: [
                            _buildInfoRow('Name', authProvider.currentUser?.name ?? 'N/A'),
                            _buildInfoRow('Contact', authProvider.currentUser?.contactNumber ?? 'N/A'),
                            _buildInfoRow('Email', authProvider.currentUser?.email ?? 'N/A'),
                            _buildInfoRow('Blood Type', 'O+ (Update in settings)'),
                            _buildInfoRow('Allergies', 'None reported (Update in settings)'),
                            _buildInfoRow('Emergency Contact', 'John Doe - +1 (555) 987-6543'),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(
                      Icons.info,
                      size: 40,
                      color: Colors.blue,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Emergency Tips',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '• Stay calm and speak clearly\n'
                      '• Provide your exact location\n'
                      '• Describe the emergency situation\n'
                      '• Follow dispatcher instructions\n'
                      '• Keep important medical information handy',
                      style: TextStyle(color: Colors.blue[700]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value),
          ),
        ],
      ),
    );
  }

  void _makeEmergencyCall(BuildContext context, Map<String, dynamic> contact) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Call ${contact['name']}?'),
        content: Text('This will call ${contact['number']}\n\n${contact['description']}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Calling ${contact['number']}...'),
                  backgroundColor: contact['color'],
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: contact['color'],
              foregroundColor: Colors.white,
            ),
            child: Text('Call Now'),
          ),
        ],
      ),
    );
  }
}
