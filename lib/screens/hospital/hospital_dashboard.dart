// Complete hospital_dashboard.dart implementation
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class HospitalDashboard extends StatefulWidget {
  @override
  _HospitalDashboardState createState() => _HospitalDashboardState();
}

class _HospitalDashboardState extends State<HospitalDashboard> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hospital Dashboard'),
        backgroundColor: Colors.red[600],
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                _logout();
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: 'logout',
                child: Text('Logout'),
              ),
            ],
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildHospitalHome(),
          _buildDoctorsManagement(),
          _buildPatientsOverview(),
          _buildReports(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.red[600],
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services),
            label: 'Doctors',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Patients',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment),
            label: 'Reports',
          ),
        ],
      ),
    );
  }

  Widget _buildHospitalHome() {
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
                        '${authProvider.currentUser?.name ?? "Hospital"} Dashboard',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Monitor hospital operations and patient care.',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildStatsCard('Total Doctors', '25', Icons.medical_services, Colors.blue),
              _buildStatsCard('Active Patients', '150', Icons.people, Colors.green),
              _buildStatsCard('Emergency Cases', '8', Icons.emergency, Colors.red),
              _buildStatsCard('Bed Occupancy', '85%', Icons.bed, Colors.orange),
            ],
          ),
          SizedBox(height: 20),
          Text(
            'Recent Activities',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                _buildActivityTile(
                  'New Patient Admission',
                  'John Doe admitted to Cardiology',
                  '30 minutes ago',
                  Colors.green,
                  Icons.person_add,
                ),
                Divider(height: 1),
                _buildActivityTile(
                  'Doctor Schedule Update',
                  'Dr. Smith updated availability',
                  '1 hour ago',
                  Colors.blue,
                  Icons.schedule,
                ),
                Divider(height: 1),
                _buildActivityTile(
                  'Emergency Alert',
                  'ICU capacity at 90%',
                  '2 hours ago',
                  Colors.red,
                  Icons.warning,
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showQuickActions(context),
                  icon: Icon(Icons.dashboard),
                  label: Text('Quick Actions'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[600],
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _generateReport(),
                  icon: Icon(Icons.file_download),
                  label: Text('Export Report'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[700],
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityTile(String title, String description, String time, Color color, IconData icon) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.2),
        child: Icon(icon, color: color),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(description),
          SizedBox(height: 4),
          Text(
            time,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorsManagement() {
    final List<Map<String, dynamic>> doctors = [
      {
        'name': 'Dr. Sarah Johnson',
        'specialization': 'Cardiology',
        'patients': 23,
        'status': 'Available',
        'rating': 4.8,
      },
      {
        'name': 'Dr. Michael Chen',
        'specialization': 'Neurology',
        'patients': 18,
        'status': 'Busy',
        'rating': 4.9,
      },
      {
        'name': 'Dr. Emily Rodriguez',
        'specialization': 'Pediatrics',
        'patients': 31,
        'status': 'Available',
        'rating': 4.7,
      },
      {
        'name': 'Dr. James Wilson',
        'specialization': 'Orthopedics',
        'patients': 15,
        'status': 'Surgery',
        'rating': 4.6,
      },
    ];

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Doctors Management',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _addNewDoctor(),
                icon: Icon(Icons.add),
                label: Text('Add Doctor'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[600],
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: doctors.length,
            itemBuilder: (context, index) {
              final doctor = doctors[index];
              return Card(
                margin: EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.red[100],
                            child: Text(
                              doctor['name'].toString().split(' ')[1][0],
                              style: TextStyle(
                                color: Colors.red[800],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  doctor['name'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  doctor['specialization'],
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Chip(
                            label: Text(doctor['status']),
                            backgroundColor: _getStatusColor(doctor['status']),
                            labelStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Icon(Icons.people, size: 16, color: Colors.grey[600]),
                                SizedBox(width: 4),
                                Text('${doctor['patients']} patients'),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Icon(Icons.star, size: 16, color: Colors.amber),
                              SizedBox(width: 4),
                              Text('${doctor['rating']}'),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => _viewDoctorDetails(doctor),
                            child: Text('View Details'),
                          ),
                          SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () => _editDoctor(doctor),
                            child: Text('Edit'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[600],
                              foregroundColor: Colors.white,
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
        ),
      ],
    );
  }

  Widget _buildPatientsOverview() {
    final List<Map<String, dynamic>> recentPatients = [
      {
        'name': 'Alice Johnson',
        'age': 45,
        'condition': 'Hypertension',
        'doctor': 'Dr. Sarah Johnson',
        'admission': '2024-02-20',
        'status': 'Stable',
      },
      {
        'name': 'Bob Smith',
        'age': 62,
        'condition': 'Diabetes',
        'doctor': 'Dr. Emily Rodriguez',
        'admission': '2024-02-19',
        'status': 'Critical',
      },
      {
        'name': 'Carol Davis',
        'age': 38,
        'condition': 'Fracture',
        'doctor': 'Dr. James Wilson',
        'admission': '2024-02-18',
        'status': 'Recovering',
      },
    ];

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Patients Overview',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildPatientStatCard(
                      'Total Patients',
                      '150',
                      Colors.blue,
                      Icons.people,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _buildPatientStatCard(
                      'New Admissions',
                      '12',
                      Colors.green,
                      Icons.person_add,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _buildPatientStatCard(
                      'Discharges',
                      '8',
                      Colors.orange,
                      Icons.exit_to_app,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: recentPatients.length,
            itemBuilder: (context, index) {
              final patient = recentPatients[index];
              return Card(
                margin: EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _getPatientStatusColor(patient['status']),
                    child: Text(
                      patient['name'].toString().split(' ')[0][0],
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    patient['name'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Age: ${patient['age']} • ${patient['condition']}'),
                      Text('Dr: ${patient['doctor']}'),
                      Text('Admitted: ${patient['admission']}'),
                    ],
                  ),
                  trailing: Chip(
                    label: Text(patient['status']),
                    backgroundColor: _getPatientStatusColor(patient['status']),
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  onTap: () => _viewPatientDetails(patient),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPatientStatCard(String title, String value, Color color, IconData icon) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
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
              fontSize: 10,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildReports() {
    final List<Map<String, dynamic>> reports = [
      {
        'title': 'Monthly Patient Report',
        'date': '2024-02-01',
        'type': 'PDF',
        'size': '2.3 MB',
      },
      {
        'title': 'Doctor Performance Analysis',
        'date': '2024-01-28',
        'type': 'Excel',
        'size': '1.8 MB',
      },
      {
        'title': 'Financial Summary',
        'date': '2024-01-25',
        'type': 'PDF',
        'size': '3.1 MB',
      },
    ];

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Reports & Analytics',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _generateNewReport(),
                icon: Icon(Icons.add),
                label: Text('Generate'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[600],
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildReportCard(
                'Patient Analytics',
                'View detailed patient statistics',
                Icons.analytics,
                Colors.blue,
                () => _showPatientAnalytics(),
              ),
              _buildReportCard(
                'Financial Reports',
                'Revenue and expense tracking',
                Icons.attach_money,
                Colors.green,
                () => _showFinancialReports(),
              ),
              _buildReportCard(
                'Staff Performance',
                'Doctor and staff metrics',
                Icons.people,
                Colors.orange,
                () => _showStaffPerformance(),
              ),
              _buildReportCard(
                'Resource Usage',
                'Equipment and bed utilization',
                Icons.inventory,
                Colors.purple,
                () => _showResourceUsage(),
              ),
            ],
          ),
          SizedBox(height: 20),
          Text(
            'Recent Reports',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final report = reports[index];
              return Card(
                margin: EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.red[100],
                    child: Icon(
                      report['type'] == 'PDF' ? Icons.picture_as_pdf : Icons.table_chart,
                      color: Colors.red[800],
                    ),
                  ),
                  title: Text(report['title']),
                  subtitle: Text('${report['date']} • ${report['size']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => _downloadReport(report),
                        icon: Icon(Icons.download),
                      ),
                      IconButton(
                        onPressed: () => _shareReport(report),
                        icon: Icon(Icons.share),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(String title, String description, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return Colors.green;
      case 'busy':
        return Colors.orange;
      case 'surgery':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getPatientStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'stable':
        return Colors.green;
      case 'critical':
        return Colors.red;
      case 'recovering':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  // Action methods
  void _showQuickActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.person_add, color: Colors.blue),
              title: Text('Add New Patient'),
              onTap: () {
                Navigator.pop(context);
                _addNewPatient();
              },
            ),
            ListTile(
              leading: Icon(Icons.medical_services, color: Colors.green),
              title: Text('Schedule Surgery'),
              onTap: () {
                Navigator.pop(context);
                _scheduleSurgery();
              },
            ),
            ListTile(
              leading: Icon(Icons.emergency, color: Colors.red),
              title: Text('Emergency Alert'),
              onTap: () {
                Navigator.pop(context);
                _sendEmergencyAlert();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _generateReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Generating hospital report...'),
        backgroundColor: Colors.red[600],
      ),
    );
  }

  void _addNewDoctor() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Add new doctor feature coming soon!')),
    );
  }

  void _viewDoctorDetails(Map<String, dynamic> doctor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(doctor['name']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Specialization: ${doctor['specialization']}'),
            Text('Patients: ${doctor['patients']}'),
            Text('Status: ${doctor['status']}'),
            Text('Rating: ${doctor['rating']}/5.0'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _editDoctor(Map<String, dynamic> doctor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit doctor feature coming soon!')),
    );
  }

  void _viewPatientDetails(Map<String, dynamic> patient) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('View patient details feature coming soon!')),
    );
  }

  void _generateNewReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Generate report feature coming soon!')),
    );
  }

  void _showPatientAnalytics() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Patient analytics feature coming soon!')),
    );
  }

  void _showFinancialReports() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Financial reports feature coming soon!')),
    );
  }

  void _showStaffPerformance() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Staff performance feature coming soon!')),
    );
  }

  void _showResourceUsage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Resource usage feature coming soon!')),
    );
  }

  void _downloadReport(Map<String, dynamic> report) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Downloading ${report['title']}...')),
    );
  }

  void _shareReport(Map<String, dynamic> report) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sharing ${report['title']}...')),
    );
  }

  void _addNewPatient() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Add patient feature coming soon!')),
    );
  }

  void _scheduleSurgery() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Schedule surgery feature coming soon!')),
    );
  }

  void _sendEmergencyAlert() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Emergency alert sent to all staff!'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _logout() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.logout();
    Navigator.pushReplacementNamed(context, '/login');
  }
}