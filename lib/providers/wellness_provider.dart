// providers/wellness_provider.dart
import 'package:flutter/foundation.dart';
import '../models/health_tip.dart' as health_tip;
import '../models/workout_plan.dart';
import '../services/api_service.dart';

class WellnessProvider with ChangeNotifier {
  List<health_tip.HealthTip> _healthTips = [];
  List<WorkoutPlan> _workoutPlans = [];
  bool _isLoading = false;

  List<health_tip.HealthTip> get healthTips => _healthTips;
  List<WorkoutPlan> get workoutPlans => _workoutPlans;
  bool get isLoading => _isLoading;

  Future<void> loadHealthTips() async {
    _isLoading = true;
    notifyListeners();

    try {
      final tipsData = await ApiService.getHealthTips();
      _healthTips = tipsData.map((data) => health_tip.HealthTip.fromJson(data)).toList();
    } catch (e) {
      print('Error loading health tips: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadWorkoutPlans() async {
    _isLoading = true;
    notifyListeners();

    try {
      final plansData = await ApiService.getWorkoutPlans();
      _workoutPlans = plansData.map((data) => WorkoutPlan.fromJson(data)).toList();
    } catch (e) {
      print('Error loading workout plans: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  List<health_tip.HealthTip> getHealthTipsByCategory(String category) {
    if (category == 'all') return _healthTips;
    return _healthTips.where((tip) => tip.category == category).toList();
  }

  List<WorkoutPlan> getWorkoutPlansByDifficulty(String difficulty) {
    return _workoutPlans.where((plan) => 
      plan.difficulty.toLowerCase() == difficulty.toLowerCase()
    ).toList();
  }
}