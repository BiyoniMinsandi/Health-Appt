// screens/patient/health_analytics_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../../providers/health_data_provider.dart';

class TimeSeriesValue {
  final DateTime timestamp;
  final double value;

  TimeSeriesValue(this.timestamp, this.value);
}

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

    // Create chart data
    final chartData = sortedData.map((data) {
      return TimeSeriesValue(
        data.timestamp,
        data.value.toDouble(),
      );
    }).toList();

    final series = [
      charts.Series<TimeSeriesValue, DateTime>(
        id: 'HealthData',
        colorFn: (_, __) => charts.MaterialPalette.teal.shadeDefault,
        domainFn: (TimeSeriesValue value, _) => value.timestamp,
        measureFn: (TimeSeriesValue value, _) => value.value,
        data: chartData,
      )
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: charts.TimeSeriesChart(
          series,
          animate: true,
          dateTimeFactory: const charts.LocalDateTimeFactory(),
          behaviors: [
            charts.ChartTitle(
              'Trend Over Time',
              behaviorPosition: charts.BehaviorPosition.top,
              titleOutsideJustification: charts.OutsideJustification.start,
            ),
          ],
          primaryMeasureAxis: charts.NumericAxisSpec(
            tickProviderSpec: charts.BasicNumericTickProviderSpec(
              zeroBound: false,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHealthInsights() {
    return Consumer<HealthDataProvider>(
      builder: (context, healthProvider, child) {
        final healthScore = healthProvider.getHealthScore();
        final recommendations = healthProvider.getHealthRecommendations();
        final bmi = healthProvider.calculateBMI();
        
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
                
                // Health Score
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getScoreColor(healthScore).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _getScoreIcon(healthScore),
                        color: _getScoreColor(healthScore),
                        size: 24,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Health Score',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '$healthScore/100 - ${_getScoreDescription(healthScore)}',
                              style: TextStyle(color: _getScoreColor(healthScore)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                if (bmi != null) ...[
                  SizedBox(height: 12),
                  _buildInsightItem(
                    '📏 BMI',
                    'Your BMI is ${bmi.toStringAsFixed(1)} - ${_getBMICategory(bmi)}',
                    _getBMIColor(bmi),
                  ),
                ],
                
                SizedBox(height: 16),
                Text(
                  'Recommendations',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                
                ...recommendations.map((recommendation) => Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.lightbulb,
                        color: Colors.amber,
                        size: 16,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          recommendation,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  IconData _getScoreIcon(int score) {
    if (score >= 80) return Icons.check_circle;
    if (score >= 60) return Icons.warning;
    return Icons.error;
  }

  String _getScoreDescription(int score) {
    if (score >= 80) return 'Excellent';
    if (score >= 60) return 'Good';
    return 'Needs Attention';
  }

  String _getBMICategory(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }

  Color _getBMIColor(double bmi) {
    if (bmi < 18.5) return Colors.blue;
    if (bmi < 25) return Colors.green;
    if (bmi < 30) return Colors.orange;
    return Colors.red;
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
