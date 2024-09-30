import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/EventCreateRequestModel.dart';
import '../../services/EventService/EventService.dart';

class AddNewEventPage extends StatefulWidget {
  final DateTime selectedDate;

  AddNewEventPage({required this.selectedDate});

  @override
  _AddNewEventPageState createState() => _AddNewEventPageState();
}

class _AddNewEventPageState extends State<AddNewEventPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _dueDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = TimeOfDay(hour: 17, minute: 0);
  String? _priority;
  bool _recurring = false;

  bool _isLoading = false;

  final EventService _eventService = EventService();

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2050),
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _startTime : _endTime,
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final start = DateTime(
      _dueDate.year,
      _dueDate.month,
      _dueDate.day,
      _startTime.hour,
      _startTime.minute,
    );
    final end = DateTime(
      _dueDate.year,
      _dueDate.month,
      _dueDate.day,
      _endTime.hour,
      _endTime.minute,
    );

    if (end.isBefore(start) || end.isAtSameMomentAs(start)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('End time must be after start time')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    if (token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Token không hợp lệ')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    String formatTimeOfDay(TimeOfDay tod) {
      final hours = tod.hour.toString().padLeft(2, '0');
      final minutes = tod.minute.toString().padLeft(2, '0');
      final seconds = '00';
      return '$hours:$minutes:$seconds';
    }

    EventCreateRequestModel newEvent = EventCreateRequestModel(
      eventTitle: _titleController.text.trim(),
      eventDescription: _descriptionController.text.trim(),
      priority: _priority!,
      startTime: formatTimeOfDay(_startTime),
      endTime: formatTimeOfDay(_endTime),
      recurring: _recurring,
    );

    try {
      final response = await _eventService.createEvent(newEvent);
      if (response['status'] == 'success' && response['data'].containsKey('eventId')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tạo sự kiện thành công!')),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? 'Failed to create event')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFE29A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'ADD NEW EVENT',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : Form(
            key: _formKey,
            child: ListView(
              children: [
                // Title input
                Text(
                  'Title',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: 'Title of event',
                    hintStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Color(0xFFFFA965),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                Text(
                  'Description',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Content',
                    hintStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Color(0xFFFFA965),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Text(
                  'Due Date',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ListTile(
                  title: Text(
                    '${DateFormat('dd/MM/yyyy').format(_dueDate)}',
                    style: TextStyle(color: Colors.black),
                  ),
                  trailing: Icon(Icons.calendar_today, color: Colors.green),
                  onTap: () => _selectDueDate(context),
                ),
                const SizedBox(height: 16),

                // Start and end time selection
                Text(
                  'Start and End Time',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: Text(
                          'Start: ${_startTime.format(context)}',
                          style: TextStyle(color: Colors.black),
                        ),
                        trailing: Icon(Icons.access_time, color: Colors.green),
                        onTap: () => _selectTime(context, true),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ListTile(
                        title: Text(
                          'End: ${_endTime.format(context)}',
                          style: TextStyle(color: Colors.black),
                        ),
                        trailing: Icon(Icons.access_time, color: Colors.green),
                        onTap: () => _selectTime(context, false),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Text(
                  'Priority',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _priority,
                  items: ['Quan trọng', 'Bình thường', 'Thường']
                      .map((priority) => DropdownMenuItem(
                    child: Text(priority),
                    value: priority,
                  ))
                      .toList(),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFFFA965),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _priority = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a priority';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Recurring switch
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recurring',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    Switch(
                      value: _recurring,
                      onChanged: (value) {
                        setState(() {
                          _recurring = value;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                Center(
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    child: Text('Xác nhận'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFFA965),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      textStyle: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
