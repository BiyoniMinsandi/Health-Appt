// providers/health_data_provider.dart
import 'package:flutter/foundation.dart';
import '../models/health_data.dart';
import '../services/database_helper.dart';

class HealthDataProvider with ChangeNotifier {
  List<HealthData> _healthDataList = [];
  bool _isLoading = false;

  List<HealthData> get healthDataList => _healthDataList;
  bool get isLoading => _isLoading;

  Future<void> addHealthData(HealthData data) async {
    _isLoading = true;
    notifyListeners();

    try {
      await DatabaseHelper.instance.insertHealthData(data);
      _healthDataList.insert(0, data);
    } catch (e) {
      print('Error adding health data: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadHealthData(String patientId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _healthDataList = await DatabaseHelper.instance.getHealthData(patientId);
    } catch (e) {
      print('Error loading health data: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  List<HealthData> getDataByType(String type) {
    return _healthDataList.where((data) => data.dataType == type).toList();
  }

  double getLatestValue(String type) {
    final typeData = getDataByType(type);
    return typeData.isNotEmpty ? typeData.first.value : 0.0;
  }

  Map<String, List<HealthData>> getGroupedData() {
    Map<String, List<HealthData>> grouped = {};
    for (var data in _healthDataList) {
      if (grouped[data.dataType] == null) {
        grouped[data.dataType] = [];
      }
      grouped[data.dataType]!.add(data);
    }
    return grouped;
  }

  // Calculate BMI if height and weight are available
  double? calculateBMI() {
    final weightData = getDataByType('Weight');
    final heightData = _healthDataList.where((data) => data.dataType == 'Height').toList();
    
    if (weightData.isNotEmpty && heightData.isNotEmpty) {
      final weight = weightData.first.value; // in kg
      final height = heightData.first.value / 100; // convert cm to m
      return weight / (height * height);
    }
    return null;
  }

  // Get health score based on latest readings
  int getHealthScore() {
    int score = 100;
    final groupedData = getGroupedData();
    
    // Blood pressure check
    final bpData = groupedData['Blood Pressure'];
    if (bpData != null && bpData.isNotEmpty) {
      final systolic = bpData.first.value;
      if (systolic > 140 || systolic < 90) score -= 20;
      else if (systolic > 130 || systolic < 100) score -= 10;
    }
    
    // Heart rate check
    final hrData = groupedData['Heart Rate'];
    if (hrData != null && hrData.isNotEmpty) {
      final hr = hrData.first.value;
      if (hr > 100 || hr < 60) score -= 15;
      else if (hr > 90 || hr < 70) score -= 5;
    }
    
    // Blood sugar check
    final bsData = groupedData['Blood Sugar'];
    if (bsData != null && bsData.isNotEmpty) {
      final bs = bsData.first.value;
      if (bs > 180 || bs < 70) score -= 25;
      else if (bs > 140 || bs < 80) score -= 10;
    }
    
    return score > 0 ? score : 0;
  }

  // Get health recommendations based on data
  List<String> getHealthRecommendations() {
    List<String> recommendations = [];
    final groupedData = getGroupedData();
    
    // Blood pressure recommendations
    final bpData = groupedData['Blood Pressure'];
    if (bpData != null && bpData.isNotEmpty) {
      final systolic = bpData.first.value;
      if (systolic > 140) {
        recommendations.add('Your blood pressure is high. Consider reducing salt intake and exercising regularly.');
      } else if (systolic < 90) {
        recommendations.add('Your blood pressure is low. Stay hydrated and consider consulting your doctor.');
      }
    }
    
    // Heart rate recommendations
    final hrData = groupedData['Heart Rate'];
    if (hrData != null && hrData.isNotEmpty) {
      final hr = hrData.first.value;
      if (hr > 100) {
        recommendations.add('Your heart rate is elevated. Try relaxation techniques and avoid caffeine.');
      }
    }
    
    // BMI recommendations
    final bmi = calculateBMI();
    if (bmi != null) {
      if (bmi > 25) {
        recommendations.add('Your BMI indicates overweight. Consider a balanced diet and regular exercise.');
      } else if (bmi < 18.5) {
        recommendations.add('Your BMI indicates underweight. Consider consulting a nutritionist.');
      }
    }
    
    if (recommendations.isEmpty) {
      recommendations.add('Your health metrics look good! Keep maintaining your healthy lifestyle.');
    }
    
    return recommendations;
  }

  // Get trend analysis for a specific data type
  String getTrendAnalysis(String dataType) {
    final typeData = getDataByType(dataType);
    if (typeData.length < 2) return 'Not enough data for trend analysis';
    
    final sortedData = List.from(typeData)
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    
    final latest = sortedData.last.value;
    final previous = sortedData[sortedData.length - 2].value;
    final change = latest - previous;
    final changePercent = (change / previous * 100).abs();
    
    if (changePercent < 2) return 'Stable';
    if (change > 0) return 'Increasing';
    return 'Decreasing';
  }
}
