// screens/patient/health_analytics_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/health_data_provider.dart';

class HealthAnalyticsScreen extends StatefulWidget {
  @override
  _HealthAnalyticsScreenState createState() => _HealthAnalyticsScreenState();
}

class _HealthAnalyticsScreenState extends State<HealthAnalyticsScreen> {
  String _selectedPeriod = 'Last 7 Days';
  final List<String> _periods = ['Last 7 Days', 'Last 30 Days', 'Last 90 Days'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Health Analytics',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                DropdownButton<String>(
                  value: _selectedPeriod,
                  items: _periods.map((period) {
                    return DropdownMenuItem(
                      value: period,
                      child: Text(period),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedPeriod = value!;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Consumer<HealthDataProvider>(
              builder: (context, healthProvider, child) {
                final groupedData = healthProvider.getGroupedData();
                
                if (groupedData.isEmpty) {
                  return Card(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Icon(
                            Icons.analytics,
                            size: 80,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No Data Available',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Start adding health data to see analytics and trends',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Column(
                  children: groupedData.entries.map((entry) {
                    return _buildAnalyticsCard(entry.key, entry.value);
                  }).toList(),
                );
              },
            ),
            SizedBox(height: 20),
            _buildHealthInsights(),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsCard(String dataType, List<dynamic> dataList) {
    final sortedData = List.from(dataList)
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    
    final latestValue = sortedData.first.value;
    final previousValue = sortedData.length > 1 ? sortedData[1].value : latestValue;
    final change = latestValue - previousValue;
    final changePercentage = previousValue != 0 ? (change / previousValue * 100) : 0;

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: _getColorForDataType(dataType),
                  child: Icon(
                    _getIconForDataType(dataType),
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dataType,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${dataList.length} readings recorded',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Latest',
                    '${latestValue.toStringAsFixed(1)} ${sortedData.first.unit}',
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Average',
                    '${_calculateAverage(dataList).toStringAsFixed(1)} ${sortedData.first.unit}',
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Change',
                    '${change >= 0 ? '+' : ''}${changePercentage.toStringAsFixed(1)}%',
                    color: change >= 0 ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              height: 100,
              child: _buildSimpleChart(dataList),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, {Color? color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: color ?? Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildSimpleChart(List<dynamic> dataList) {
    final sortedData = List.from(dataList)
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    
    if (sortedData.length < 2) {
      return Container(
        alignment: Alignment.center,
        child: Text(
          'Need more data points for chart',
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          '📈 Chart visualization would go here\n(${sortedData.length} data points)',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey[600]),
        ),
      ),
    );
  }

  Widget _buildHealthInsights() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Health Insights',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            _buildInsightItem(
              '🎯 Goal Achievement',
              'You\'re on track with your health monitoring!',
              Colors.green,
            ),
            SizedBox(height: 12),
            _buildInsightItem(
              '📊 Data Consistency',
              'Try to record data at consistent times daily.',
              Colors.orange,
            ),
            SizedBox(height: 12),
            _buildInsightItem(
              '💡 Recommendation',
              'Consider tracking your sleep and exercise data too.',
              Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightItem(String title, String description, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  double _calculateAverage(List<dynamic> dataList) {
    if (dataList.isEmpty) return 0.0;
    double sum = dataList.fold(0.0, (sum, data) => sum + data.value);
    return sum / dataList.length;
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
      case 'temperature':
        return Colors.purple;
      case 'cholesterol':
        return Colors.teal;
      case 'bmi':
        return Colors.indigo;
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
      case 'temperature':
        return Icons.thermostat;
      case 'cholesterol':
        return Icons.opacity;
      case 'bmi':
        return Icons.calculate;
      default:
        return Icons.health_and_safety;
    }
  }
}
