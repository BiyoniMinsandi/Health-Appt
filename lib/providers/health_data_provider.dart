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
}
