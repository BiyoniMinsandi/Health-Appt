// screens/patient/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/health_data_provider.dart';
import 'add_health_data_screen.dart';
import 'health_analytics_screen.dart';
import 'chat_list_screen.dart';
import 'medication_reminders_screen.dart';
import '../common/emergency_screen.dart';
import '../common/health_reports_screen.dart';

class PatientDashboard extends StatefulWidget {
  @override
  _PatientDashboardState createState() => _PatientDashboardState();
}

class _PatientDashboardState extends State<PatientDashboard> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final healthProvider = Provider.of<HealthDataProvider>(context, listen: false);
      if (authProvider.currentUser != null) {
        healthProvider.loadHealthData(authProvider.currentUser!.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Health Dashboard'),
        backgroundColor: Colors.teal[600],
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                _logout();
              } else if (value == 'settings') {
                Navigator.pushNamed(context, '/settings');
              } else if (value == 'reports') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HealthReportsScreen(),
                  ),
                );
              } else if (value == 'medications') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MedicationRemindersScreen(),
                  ),
                );
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: 'reports',
                child: Row(
                  children: [
                    Icon(Icons.assessment, color: Colors.grey[600]),
                    SizedBox(width: 8),
                    Text('Health Reports'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'medications',
                child: Row(
                  children: [
                    Icon(Icons.medical_services, color: Colors.grey[600]),
                    SizedBox(width: 8),
                    Text('Medications'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings, color: Colors.grey[600]),
                    SizedBox(width: 8),
                    Text('Settings'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.grey[600]),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          _buildDashboardHome(),
          AddHealthDataScreen(),
          HealthAnalyticsScreen(),
          ChatListScreen(),
          EmergencyScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _pageController.animateToPage(
            index,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.teal[600],
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: 'Add Data',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emergency),
            label: 'Emergency',
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardHome() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome, ${authProvider.currentUser?.name ?? "User"}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Track your health data and stay connected with your healthcare providers.',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 20),
          
          // Health Score Section
          Consumer<HealthDataProvider>(
            builder: (context, healthProvider, child) {
              final healthScore = healthProvider.getHealthScore();
              final bmi = healthProvider.calculateBMI();
              
              return Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Health Overview',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildHealthMetric(
                              'Health Score',
                              '$healthScore/100',
                              Icons.health_and_safety,
                              _getScoreColor(healthScore),
                            ),
                          ),
                          if (bmi != null)
                            Expanded(
                              child: _buildHealthMetric(
                                'BMI',
                                bmi.toStringAsFixed(1),
                                Icons.calculate,
                                _getBMIColor(bmi),
                              ),
                            ),
                          Expanded(
                            child: _buildHealthMetric(
                              'Records',
                              '${healthProvider.healthDataList.length}',
                              Icons.analytics,
                              Colors.teal[600]!,
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
          Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildQuickActionCard(
                'Blood Pressure',
                Icons.favorite,
                Colors.red,
                () => _navigateToAddData('Blood Pressure'),
              ),
              _buildQuickActionCard(
                'Heart Rate',
                Icons.monitor_heart,
                Colors.pink,
                () => _navigateToAddData('Heart Rate'),
              ),
              _buildQuickActionCard(
                'Weight',
                Icons.fitness_center,
                Colors.green,
                () => _navigateToAddData('Weight'),
              ),
              _buildQuickActionCard(
                'Blood Sugar',
                Icons.water_drop,
                Colors.orange,
                () => _navigateToAddData('Blood Sugar'),
              ),
            ],
          ),
          SizedBox(height: 20),
          Consumer<HealthDataProvider>(
            builder: (context, healthProvider, child) {
              return Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Latest Readings',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      if (healthProvider.healthDataList.isEmpty)
                        Text(
                          'No health data recorded yet. Start by adding your first measurement!',
                          style: TextStyle(color: Colors.grey[600]),
                        )
                      else
                        Column(
                          children: healthProvider.getGroupedData().entries.take(3).map((entry) {
                            final latestData = entry.value.first;
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: _getColorForDataType(entry.key),
                                child: Icon(
                                  _getIconForDataType(entry.key),
                                  color: Colors.white,
                                ),
                              ),
                              title: Text(entry.key),
                              subtitle: Text(
                                '${latestData.value} ${latestData.unit}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              trailing: Text(
                                _formatDate(latestData.timestamp),
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            );
                          }).toList(),
                        ),
                    ],
                  ),
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
                    'Health Tips',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '💡 Daily Health Tip',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Drink at least 8 glasses of water daily to maintain proper hydration and support overall health.',
                          style: TextStyle(color: Colors.blue[700]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: color,
              ),
              SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getColorForDataType(String type) {
    switch (type.toLowerCase()) {
      case 'blood pressure':
        return Colors.red;
      case 'heart rate':
        return Colors.pink;
      case 'weight':
        return Colors.green;
      case 'blood sugar':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  IconData _getIconForDataType(String type) {
    switch (type.toLowerCase()) {
      case 'blood pressure':
        return Icons.favorite;
      case 'heart rate':
        return Icons.monitor_heart;
      case 'weight':
        return Icons.fitness_center;
      case 'blood sugar':
        return Icons.water_drop;
      default:
        return Icons.health_and_safety;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _navigateToAddData(String dataType) {
    setState(() {
      _currentIndex = 1;
    });
    _pageController.animateToPage(
      1,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _logout() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.logout();
    Navigator.pushReplacementNamed(context, '/login');
  }

  Widget _buildHealthMetric(String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  Color _getBMIColor(double bmi) {
    if (bmi < 18.5) return Colors.blue;
    if (bmi < 25) return Colors.green;
    if (bmi < 30) return Colors.orange;
    return Colors.red;
  }
}
