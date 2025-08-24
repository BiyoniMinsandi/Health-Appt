// screens/patient/add_health_data_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../../models/health_data.dart';
import '../../providers/health_data_provider.dart';
import '../../providers/auth_provider.dart';

class AddHealthDataScreen extends StatefulWidget {
  @override
  _AddHealthDataScreenState createState() => _AddHealthDataScreenState();
}

class _AddHealthDataScreenState extends State<AddHealthDataScreen> {
  final _formKey = GlobalKey<FormState>();
  final _valueController = TextEditingController();
  final _notesController = TextEditingController();
  String _selectedDataType = 'Blood Pressure';
  String _selectedUnit = 'mmHg';
  
  final List<String> _dataTypes = [
    'Blood Pressure',
    'Heart Rate',
    'Weight',
    'Blood Sugar',
    'Temperature',
    'Cholesterol',
    'BMI',
  ];

  final Map<String, List<String>> _unitsForType = {
    'Blood Pressure': ['mmHg'],
    'Heart Rate': ['bpm'],
    'Weight': ['kg', 'lbs'],
    'Blood Sugar': ['mg/dL', 'mmol/L'],
    'Temperature': ['°C', '°F'],
    'Cholesterol': ['mg/dL'],
    'BMI': ['kg/m²'],
  };

  SpeechToText? _speechToText;
  bool _speechEnabled = false;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    _speechToText = SpeechToText();
    _speechEnabled = await _speechToText!.initialize();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Health Data',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      DropdownButtonFormField<String>(
                        value: _selectedDataType,
                        decoration: InputDecoration(
                          labelText: 'Data Type',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.category),
                        ),
                        items: _dataTypes.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedDataType = value!;
                            _selectedUnit = _unitsForType[value]!.first;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: _valueController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Value',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.numbers),
                                suffixIcon: _speechEnabled
                                    ? IconButton(
                                        onPressed: _isListening ? _stopListening : _startListening,
                                        icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                                        color: _isListening ? Colors.red : Colors.grey,
                                      )
                                    : null,
                              ),
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Please enter a value';
                                }
                                if (double.tryParse(value!) == null) {
                                  return 'Please enter a valid number';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedUnit,
                              decoration: InputDecoration(
                                labelText: 'Unit',
                                border: OutlineInputBorder(),
                              ),
                              items: _unitsForType[_selectedDataType]!.map((unit) {
                                return DropdownMenuItem(
                                  value: unit,
                                  child: Text(unit),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedUnit = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _notesController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Notes (Optional)',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.note),
                          hintText: 'Add any additional notes about this reading...',
                        ),
                      ),
                      SizedBox(height: 24),
                      Consumer<HealthDataProvider>(
                        builder: (context, healthProvider, child) {
                          return SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: healthProvider.isLoading ? null : _saveHealthData,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal[600],
                                foregroundColor: Colors.white,
                              ),
                              child: healthProvider.isLoading
                                  ? CircularProgressIndicator(color: Colors.white)
                                  : Text(
                                      'Save Health Data',
                                      style: TextStyle(fontSize: 18),
                                    ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              if (_speechEnabled)
                Card(
                  color: Colors.teal[50],
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Icon(
                          Icons.accessibility,
                          size: 40,
                          color: Colors.teal[600],
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Voice Input Available',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.teal[800],
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Tap the microphone icon to speak your health data values',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.teal[700]),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _startListening() async {
    if (!_speechEnabled) return;
    
    await _speechToText!.listen(
      onResult: (result) {
        setState(() {
          _valueController.text = result.recognizedWords;
        });
      },
    );
    setState(() {
      _isListening = true;
    });
  }

  void _stopListening() async {
    await _speechToText!.stop();
    setState(() {
      _isListening = false;
    });
  }

  void _saveHealthData() async {
    if (_formKey.currentState?.validate() ?? false) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final healthProvider = Provider.of<HealthDataProvider>(context, listen: false);

      if (authProvider.currentUser != null) {
        final healthData = HealthData(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          patientId: authProvider.currentUser!.id,
          dataType: _selectedDataType,
          value: double.parse(_valueController.text),
          unit: _selectedUnit,
          timestamp: DateTime.now(),
          notes: _notesController.text.isEmpty ? null : _notesController.text,
        );

        await healthProvider.addHealthData(healthData);

        // Clear form
        _valueController.clear();
        _notesController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Health data saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _valueController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}