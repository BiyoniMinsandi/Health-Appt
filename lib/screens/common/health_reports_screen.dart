// screens/common/health_reports_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/health_data_provider.dart';
import '../../providers/auth_provider.dart';

class HealthReport {
  final String id;
  final String title;
  final DateTime dateGenerated;
  final String period;
  final Map<String, dynamic> data;

  HealthReport({
    required this.id,
    required this.title,
    required this.dateGenerated,
    required this.period,
    required this.data,
  });
}

class HealthReportsScreen extends StatefulWidget {
  @override
  _HealthReportsScreenState createState() => _HealthReportsScreenState();
}

class _HealthReportsScreenState extends State<HealthReportsScreen> {
  List<HealthReport> _reports = [];
  bool _isGenerating = false;

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  void _loadReports() {
    // Sample reports - in a real app, these would be loaded from a database
    _reports = [
      HealthReport(
        id: '1',
        title: 'Monthly Health Summary',
        dateGenerated: DateTime.now().subtract(Duration(days: 2)),
        period: 'February 2024',
        data: {
          'totalReadings': 45,
          'averageBP': '125/82',
          'averageHR': 72,
          'healthScore': 85,
        },
      ),
      HealthReport(
        id: '2',
        title: 'Weekly Wellness Report',
        dateGenerated: DateTime.now().subtract(Duration(days: 7)),
        period: 'Feb 12-18, 2024',
        data: {
          'totalReadings': 12,
          'averageBP': '128/85',
          'averageHR': 75,
          'healthScore': 82,
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Health Reports'),
        backgroundColor: Colors.teal[600],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Generate New Report Section
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Generate New Report',
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
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.5,
                      children: [
                        _buildReportTypeCard(
                          'Weekly Summary',
                          'Last 7 days',
                          Icons.calendar_view_week,
                          Colors.blue,
                          () => _generateReport('weekly'),
                        ),
                        _buildReportTypeCard(
                          'Monthly Report',
                          'Last 30 days',
                          Icons.calendar_view_month,
                          Colors.green,
                          () => _generateReport('monthly'),
                        ),
                        _buildReportTypeCard(
                          'Custom Period',
                          'Choose dates',
                          Icons.date_range,
                          Colors.orange,
                          () => _generateCustomReport(),
                        ),
                        _buildReportTypeCard(
                          'Full History',
                          'All data',
                          Icons.history,
                          Colors.purple,
                          () => _generateReport('all'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 20),
            
            // Quick Health Overview
            Consumer<HealthDataProvider>(
              builder: (context, healthProvider, child) {
                final healthScore = healthProvider.getHealthScore();
                final recommendations = healthProvider.getHealthRecommendations();
                
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
                              child: _buildOverviewCard(
                                'Health Score',
                                '$healthScore/100',
                                Icons.health_and_safety,
                                _getScoreColor(healthScore),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: _buildOverviewCard(
                                'Total Records',
                                '${healthProvider.healthDataList.length}',
                                Icons.analytics,
                                Colors.teal[600]!,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: _buildOverviewCard(
                                'Data Types',
                                '${healthProvider.getGroupedData().length}',
                                Icons.category,
                                Colors.blue[600]!,
                              ),
                            ),
                          ],
                        ),
                        if (recommendations.isNotEmpty) ...[
                          SizedBox(height: 16),
                          Text(
                            'Key Recommendations',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          ...recommendations.take(2).map((rec) => Padding(
                            padding: EdgeInsets.only(bottom: 4),
                            child: Row(
                              children: [
                                Icon(Icons.lightbulb, size: 16, color: Colors.amber),
                                SizedBox(width: 8),
                                Expanded(child: Text(rec, style: TextStyle(fontSize: 14))),
                              ],
                            ),
                          )),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
            
            SizedBox(height: 20),
            
            // Existing Reports
            Text(
              'Generated Reports',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            
            if (_reports.isEmpty)
              Card(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Icon(
                        Icons.assessment,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No Reports Generated',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Generate your first health report to track your progress',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _reports.length,
                itemBuilder: (context, index) {
                  final report = _reports[index];
                  return _buildReportCard(report);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportTypeCard(String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      child: InkWell(
        onTap: _isGenerating ? null : onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 28),
              SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                subtitle,
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

  Widget _buildOverviewCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
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

  Widget _buildReportCard(HealthReport report) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        report.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        report.period,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.assessment, color: Colors.teal[600]),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                SizedBox(width: 4),
                Text(
                  'Generated: ${DateFormat('MMM dd, yyyy').format(report.dateGenerated)}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
            SizedBox(height: 12),
            // Report summary
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildReportStat('Readings', '${report.data['totalReadings']}'),
                  _buildReportStat('Avg BP', '${report.data['averageBP']}'),
                  _buildReportStat('Avg HR', '${report.data['averageHR']} bpm'),
                  _buildReportStat('Score', '${report.data['healthScore']}/100'),
                ],
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => _shareReport(report),
                  icon: Icon(Icons.share, size: 16),
                  label: Text('Share'),
                ),
                SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () => _downloadReport(report),
                  icon: Icon(Icons.download, size: 16),
                  label: Text('Download'),
                ),
                SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () => _viewReport(report),
                  icon: Icon(Icons.visibility, size: 16),
                  label: Text('View'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal[600],
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  Future<void> _generateReport(String type) async {
    setState(() {
      _isGenerating = true;
    });

    // Simulate report generation
    await Future.delayed(Duration(seconds: 2));

    final healthProvider = Provider.of<HealthDataProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    String title;
    String period;
    
    switch (type) {
      case 'weekly':
        title = 'Weekly Health Summary';
        period = 'Last 7 days';
        break;
      case 'monthly':
        title = 'Monthly Health Report';
        period = 'Last 30 days';
        break;
      case 'all':
        title = 'Complete Health History';
        period = 'All time';
        break;
      default:
        title = 'Health Report';
        period = 'Custom period';
    }

    final newReport = HealthReport(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      dateGenerated: DateTime.now(),
      period: period,
      data: {
        'totalReadings': healthProvider.healthDataList.length,
        'averageBP': '125/82',
        'averageHR': 72,
        'healthScore': healthProvider.getHealthScore(),
      },
    );

    setState(() {
      _reports.insert(0, newReport);
      _isGenerating = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title generated successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _generateCustomReport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Custom Report Period'),
        content: Text('Select a custom date range for your health report.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _generateReport('custom');
            },
            child: Text('Generate'),
          ),
        ],
      ),
    );
  }

  void _viewReport(HealthReport report) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _ReportDetailScreen(report: report),
      ),
    );
  }

  void _shareReport(HealthReport report) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sharing ${report.title}...')),
    );
  }

  void _downloadReport(HealthReport report) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Downloading ${report.title}...')),
    );
  }
}

class _ReportDetailScreen extends StatelessWidget {
  final HealthReport report;

  _ReportDetailScreen({required this.report});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(report.title),
        backgroundColor: Colors.teal[600],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Report Summary',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text('Period: ${report.period}'),
                    Text('Generated: ${DateFormat('MMM dd, yyyy hh:mm a').format(report.dateGenerated)}'),
                    SizedBox(height: 16),
                    Text(
                      'Health Metrics',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('Total Readings: ${report.data['totalReadings']}'),
                    Text('Average Blood Pressure: ${report.data['averageBP']} mmHg'),
                    Text('Average Heart Rate: ${report.data['averageHR']} bpm'),
                    Text('Health Score: ${report.data['healthScore']}/100'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Detailed Analysis',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'This is a placeholder for detailed health analysis. In a complete implementation, this would include:',
                    ),
                    SizedBox(height: 8),
                    Text('• Detailed charts and graphs'),
                    Text('• Trend analysis'),
                    Text('• Health recommendations'),
                    Text('• Comparison with previous periods'),
                    Text('• Risk assessments'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}