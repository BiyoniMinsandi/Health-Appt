// services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://your-backend-url.com/api';
  
  // Health tips and workout suggestions
  static Future<List<Map<String, dynamic>>> getHealthTips() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/health-tips'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      }
    } catch (e) {
      print('Error fetching health tips: $e');
    }
    
    // Return mock data if API fails
    return [
      {
        'id': '1',
        'title': 'Stay Hydrated',
        'description': 'Drink at least 8 glasses of water daily for optimal health.',
        'category': 'nutrition',
        'icon': '💧'
      },
      {
        'id': '2',
        'title': 'Regular Exercise',
        'description': 'Aim for 30 minutes of moderate exercise daily.',
        'category': 'fitness',
        'icon': '🏃'
      },
      {
        'id': '3',
        'title': 'Quality Sleep',
        'description': 'Get 7-9 hours of quality sleep each night.',
        'category': 'wellness',
        'icon': '😴'
      },
    ];
  }

  static Future<List<Map<String, dynamic>>> getWorkoutPlans() async {
    // Mock workout plans - integrate with AI service later
    return [
      {
        'id': '1',
        'title': 'Beginner Cardio',
        'duration': '20 minutes',
        'difficulty': 'Beginner',
        'exercises': ['Walking', 'Light jogging', 'Stretching'],
        'description': 'Perfect for starting your fitness journey'
      },
      {
        'id': '2',
        'title': 'Strength Training',
        'duration': '30 minutes',
        'difficulty': 'Intermediate',
        'exercises': ['Push-ups', 'Squats', 'Planks', 'Lunges'],
        'description': 'Build muscle and increase strength'
      },
    ];
  }
}