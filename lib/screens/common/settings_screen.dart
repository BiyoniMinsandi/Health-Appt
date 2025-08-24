// screens/common/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/biometric_service.dart';
import '../../services/notification_service.dart';
import 'package:local_auth/local_auth.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _biometricEnabled = false;
  bool _medicationReminders = true;
  bool _healthDataReminders = true;
  bool _voiceAssistant = true;
  bool _darkMode = false;
  List<BiometricType> _availableBiometrics = [];

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
  }

  Future<void> _checkBiometricAvailability() async {
    final isAvailable = await BiometricService.isAvailable();
    final availableBiometrics = await BiometricService.getAvailableBiometrics();
    
    setState(() {
      _availableBiometrics = availableBiometrics;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.teal[600],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Profile',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.teal[100],
                              child: Icon(
                                Icons.person,
                                size: 30,
                                color: Colors.teal[600],
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    authProvider.currentUser?.name ?? 'User',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    authProvider.currentUser?.email ?? '',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                  Text(
                                    'Type: ${authProvider.currentUser?.userType ?? 'Patient'}',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ],
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
            
            SizedBox(height: 20),
            
            // Security Section
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Security',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    
                    if (_availableBiometrics.isNotEmpty)
                      SwitchListTile(
                        title: Text('${BiometricService.getBiometricTypeString(_availableBiometrics)} Login'),
                        subtitle: Text('Use biometric authentication to login'),
                        value: _biometricEnabled,
                        onChanged: (value) async {
                          if (value) {
                            final authenticated = await BiometricService.authenticate(
                              reason: 'Enable biometric login for secure access',
                            );
                            if (authenticated) {
                              setState(() {
                                _biometricEnabled = value;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Biometric login enabled')),
                              );
                            }
                          } else {
                            setState(() {
                              _biometricEnabled = value;
                            });
                          }
                        },
                        activeColor: Colors.teal[600],
                      ),
                    
                    ListTile(
                      title: Text('Change Password'),
                      subtitle: Text('Update your account password'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Change password feature coming soon!')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 20),
            
            // Notifications Section
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notifications',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    
                    SwitchListTile(
                      title: Text('Medication Reminders'),
                      subtitle: Text('Get notified when it\'s time to take medication'),
                      value: _medicationReminders,
                      onChanged: (value) {
                        setState(() {
                          _medicationReminders = value;
                        });
                        if (value) {
                          NotificationService().showMedicationReminder('Sample Medication', '10mg');
                        }
                      },
                      activeColor: Colors.teal[600],
                    ),
                    
                    SwitchListTile(
                      title: Text('Health Data Reminders'),
                      subtitle: Text('Get reminded to log your health data'),
                      value: _healthDataReminders,
                      onChanged: (value) {
                        setState(() {
                          _healthDataReminders = value;
                        });
                        if (value) {
                          NotificationService().scheduleHealthReminder(
                            'Daily Health Check',
                            'Don\'t forget to log your health data',
                            DateTime.now().add(Duration(hours: 1)),
                          );
                        }
                      },
                      activeColor: Colors.teal[600],
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 20),
            
            // Accessibility Section
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Accessibility',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    
                    SwitchListTile(
                      title: Text('Voice Assistant'),
                      subtitle: Text('Enable voice commands and text-to-speech'),
                      value: _voiceAssistant,
                      onChanged: (value) {
                        setState(() {
                          _voiceAssistant = value;
                        });
                      },
                      activeColor: Colors.teal[600],
                    ),
                    
                    ListTile(
                      title: Text('Text Size'),
                      subtitle: Text('Adjust text size for better readability'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Text size settings coming soon!')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 20),
            
            // Data & Privacy Section
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Data & Privacy',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    
                    ListTile(
                      title: Text('Export Health Data'),
                      subtitle: Text('Download your health data'),
                      trailing: Icon(Icons.download),
                      onTap: () {
                        _exportHealthData();
                      },
                    ),
                    
                    ListTile(
                      title: Text('Privacy Policy'),
                      subtitle: Text('View our privacy policy'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Privacy policy coming soon!')),
                        );
                      },
                    ),
                    
                    ListTile(
                      title: Text('Terms of Service'),
                      subtitle: Text('View terms of service'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Terms of service coming soon!')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 20),
            
            // Logout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _logout,
                icon: Icon(Icons.logout),
                label: Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[600],
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _exportHealthData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Export Health Data'),
        content: Text('Your health data will be exported as a CSV file. This includes all your health measurements and records.'),
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
                  content: Text('Health data export started...'),
                  backgroundColor: Colors.teal[600],
                ),
              );
            },
            child: Text('Export'),
          ),
        ],
      ),
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              await authProvider.logout();
              Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }
}