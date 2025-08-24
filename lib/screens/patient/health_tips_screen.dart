// screens/patient/health_tips_screen.dart
import 'package:flutter/material.dart';
import 'package:text_to_speech/text_to_speech.dart';
import '../../models/health_tip.dart';
import '../../services/api_service.dart';

class HealthTipsScreen extends StatefulWidget {
  @override
  _HealthTipsScreenState createState() => _HealthTipsScreenState();
}

class _HealthTipsScreenState extends State<HealthTipsScreen> {
  List<HealthTip> _healthTips = [];
  bool _isLoading = true;
  String _selectedCategory = 'all';
  TextToSpeech tts = TextToSpeech();

  final List<String> _categories = ['all', 'nutrition', 'fitness', 'wellness', 'mental'];

  @override
  void initState() {
    super.initState();
    _loadHealthTips();
  }

  Future<void> _loadHealthTips() async {
    try {
      final tipsData = await ApiService.getHealthTips();
      if (tipsData != null && tipsData is List) {
        setState(() {
          _healthTips = tipsData
              .whereType<Map<String, dynamic>>()
              .map<HealthTip>((data) => HealthTip.fromJson(data))
              .toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _healthTips = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Health Tips'),
        backgroundColor: Colors.green[600],
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category == _selectedCategory;

                return Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(category.toUpperCase()),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    selectedColor: Colors.green[600],
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: _getFilteredTips().length,
                    itemBuilder: (context, index) {
                      final tip = _getFilteredTips()[index];
                      return Card(
                        margin: EdgeInsets.only(bottom: 16),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    tip.icon,
                                    style: TextStyle(fontSize: 24),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      tip.title,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.volume_up),
                                    color: Colors.teal[600],
                                    onPressed: () => _speakHealthTip(tip),
                                    tooltip: 'Listen to health tip',
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Text(
                                tip.description,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                              SizedBox(height: 8),
                              Chip(
                                label: Text(tip.category.toUpperCase()),
                                backgroundColor: Colors.green[100],
                                labelStyle: TextStyle(
                                  color: Colors.green[800],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  List<HealthTip> _getFilteredTips() {
    if (_selectedCategory == 'all') {
      return _healthTips;
    }
    return _healthTips
        .where((tip) =>
            tip.category.toLowerCase() == _selectedCategory.toLowerCase())
        .toList();
  }

  Future<void> _speakHealthTip(HealthTip tip) async {
    final textToSpeak = "${tip.title}. ${tip.description}";
    await tts.speak(textToSpeak);
  }
}
