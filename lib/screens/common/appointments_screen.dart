// screens/common/appointments_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Appointment {
  final String id;
  final String patientName;
  final String doctorName;
  final DateTime dateTime;
  final String type;
  final String status;
  final String? notes;

  Appointment({
    required this.id,
    required this.patientName,
    required this.doctorName,
    required this.dateTime,
    required this.type,
    required this.status,
    this.notes,
  });
}

class AppointmentsScreen extends StatefulWidget {
  final String userType;
  
  AppointmentsScreen({required this.userType});

  @override
  _AppointmentsScreenState createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  List<Appointment> _appointments = [
    Appointment(
      id: '1',
      patientName: 'John Smith',
      doctorName: 'Dr. Sarah Johnson',
      dateTime: DateTime.now().add(Duration(days: 1, hours: 2)),
      type: 'Consultation',
      status: 'Confirmed',
      notes: 'Follow-up for blood pressure monitoring',
    ),
    Appointment(
      id: '2',
      patientName: 'Alice Johnson',
      doctorName: 'Dr. Michael Chen',
      dateTime: DateTime.now().add(Duration(days: 2, hours: 4)),
      type: 'Check-up',
      status: 'Pending',
      notes: 'Annual health screening',
    ),
    Appointment(
      id: '3',
      patientName: 'Bob Wilson',
      doctorName: 'Dr. Emily Rodriguez',
      dateTime: DateTime.now().add(Duration(days: 3, hours: 1)),
      type: 'Consultation',
      status: 'Confirmed',
      notes: 'Review test results',
    ),
    Appointment(
      id: '4',
      patientName: 'Carol Davis',
      doctorName: 'Dr. James Wilson',
      dateTime: DateTime.now().subtract(Duration(days: 1)),
      type: 'Surgery Follow-up',
      status: 'Completed',
      notes: 'Post-operative check',
    ),
  ];

  String _selectedFilter = 'Upcoming';
  final List<String> _filters = ['All', 'Upcoming', 'Pending', 'Confirmed', 'Completed'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointments'),
        backgroundColor: Colors.teal[600],
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Filter Tabs
          Container(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _filters.length,
              itemBuilder: (context, index) {
                final filter = _filters[index];
                final isSelected = filter == _selectedFilter;

                return Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                    selectedColor: Colors.teal[600],
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Appointments List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _getFilteredAppointments().length,
              itemBuilder: (context, index) {
                final appointment = _getFilteredAppointments()[index];
                return _buildAppointmentCard(appointment);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _scheduleNewAppointment,
        backgroundColor: Colors.teal[600],
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildAppointmentCard(Appointment appointment) {
    final bool isPast = appointment.dateTime.isBefore(DateTime.now());
    final Color statusColor = _getStatusColor(appointment.status);

    return Card(
      margin: EdgeInsets.only(bottom: 16),
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
                        widget.userType == 'patient' 
                            ? 'Dr. ${appointment.doctorName.split(' ').last}'
                            : appointment.patientName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        appointment.type,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Chip(
                  label: Text(appointment.status),
                  backgroundColor: statusColor,
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
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                SizedBox(width: 8),
                Text(
                  DateFormat('MMM dd, yyyy').format(appointment.dateTime),
                  style: TextStyle(color: Colors.grey[600]),
                ),
                SizedBox(width: 16),
                Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                SizedBox(width: 8),
                Text(
                  DateFormat('hh:mm a').format(appointment.dateTime),
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            if (appointment.notes != null) ...[
              SizedBox(height: 8),
              Text(
                appointment.notes!,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14,
                ),
              ),
            ],
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!isPast && appointment.status != 'Completed') ...[
                  if (appointment.status == 'Pending') ...[
                    TextButton(
                      onPressed: () => _updateAppointmentStatus(appointment, 'Confirmed'),
                      child: Text('Confirm'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.green,
                      ),
                    ),
                    SizedBox(width: 8),
                  ],
                  TextButton(
                    onPressed: () => _rescheduleAppointment(appointment),
                    child: Text('Reschedule'),
                  ),
                  SizedBox(width: 8),
                  TextButton(
                    onPressed: () => _cancelAppointment(appointment),
                    child: Text('Cancel'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                  ),
                ],
                if (appointment.status == 'Confirmed' && !isPast) ...[
                  ElevatedButton(
                    onPressed: () => _startConsultation(appointment),
                    child: Text('Start'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal[600],
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Appointment> _getFilteredAppointments() {
    switch (_selectedFilter) {
      case 'Upcoming':
        return _appointments.where((apt) => 
          apt.dateTime.isAfter(DateTime.now()) && apt.status != 'Cancelled'
        ).toList()..sort((a, b) => a.dateTime.compareTo(b.dateTime));
      case 'Pending':
        return _appointments.where((apt) => apt.status == 'Pending').toList();
      case 'Confirmed':
        return _appointments.where((apt) => apt.status == 'Confirmed').toList();
      case 'Completed':
        return _appointments.where((apt) => apt.status == 'Completed').toList();
      default:
        return _appointments..sort((a, b) => b.dateTime.compareTo(a.dateTime));
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _scheduleNewAppointment() {
    showDialog(
      context: context,
      builder: (context) => _AppointmentScheduleDialog(),
    );
  }

  void _updateAppointmentStatus(Appointment appointment, String newStatus) {
    setState(() {
      final index = _appointments.indexWhere((apt) => apt.id == appointment.id);
      if (index != -1) {
        _appointments[index] = Appointment(
          id: appointment.id,
          patientName: appointment.patientName,
          doctorName: appointment.doctorName,
          dateTime: appointment.dateTime,
          type: appointment.type,
          status: newStatus,
          notes: appointment.notes,
        );
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Appointment $newStatus'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _rescheduleAppointment(Appointment appointment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reschedule Appointment'),
        content: Text('Select a new date and time for your appointment.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Reschedule feature coming soon!')),
              );
            },
            child: Text('Reschedule'),
          ),
        ],
      ),
    );
  }

  void _cancelAppointment(Appointment appointment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cancel Appointment'),
        content: Text('Are you sure you want to cancel this appointment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _updateAppointmentStatus(appointment, 'Cancelled');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Cancel Appointment'),
          ),
        ],
      ),
    );
  }

  void _startConsultation(Appointment appointment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Start Consultation'),
        content: Text('This will start a virtual consultation with ${appointment.patientName}.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Video consultation starting...'),
                  backgroundColor: Colors.teal[600],
                ),
              );
            },
            child: Text('Start'),
          ),
        ],
      ),
    );
  }
}

class _AppointmentScheduleDialog extends StatefulWidget {
  @override
  __AppointmentScheduleDialogState createState() => __AppointmentScheduleDialogState();
}

class __AppointmentScheduleDialogState extends State<_AppointmentScheduleDialog> {
  final _formKey = GlobalKey<FormState>();
  final _patientController = TextEditingController();
  final _doctorController = TextEditingController();
  final _notesController = TextEditingController();
  
  DateTime _selectedDate = DateTime.now().add(Duration(days: 1));
  TimeOfDay _selectedTime = TimeOfDay(hour: 9, minute: 0);
  String _selectedType = 'Consultation';
  
  final List<String> _appointmentTypes = [
    'Consultation',
    'Check-up',
    'Follow-up',
    'Emergency',
    'Surgery',
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Schedule Appointment'),
      content: SizedBox(
        width: double.maxFinite,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _patientController,
                  decoration: InputDecoration(
                    labelText: 'Patient Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter patient name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _doctorController,
                  decoration: InputDecoration(
                    labelText: 'Doctor Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter doctor name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedType,
                  decoration: InputDecoration(
                    labelText: 'Appointment Type',
                    border: OutlineInputBorder(),
                  ),
                  items: _appointmentTypes.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value!;
                    });
                  },
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: Text('Date'),
                        subtitle: Text(DateFormat('MMM dd, yyyy').format(_selectedDate)),
                        onTap: _selectDate,
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: Text('Time'),
                        subtitle: Text(_selectedTime.format(context)),
                        onTap: _selectTime,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _notesController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Notes (Optional)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _scheduleAppointment,
          child: Text('Schedule'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal[600],
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _scheduleAppointment() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Appointment scheduled successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  void dispose() {
    _patientController.dispose();
    _doctorController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}