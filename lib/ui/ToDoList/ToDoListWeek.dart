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
            fontFamily: 'Arista', // Set font to Arista
            fontSize: 35,
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
                  style: TextStyle(
                    fontFamily: 'Arista', // Set font to Arista
                    color: Colors.black,
                    fontSize: 21
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: 'Title of event',
                    hintStyle: TextStyle(color: Colors.white, fontFamily: 'KeepCalm'),
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
                const SizedBox(height: 13),

                Text(
                  'Description',
                  style: TextStyle(
                    fontFamily: 'Arista', // Set font to Arista
                    color: Colors.black,
                      fontSize: 21
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Content',
                    hintStyle: TextStyle(color: Colors.white, fontFamily: 'KeepCalm'),
                    filled: true,
                    fillColor: Color(0xFFFFA965),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Due Date
                const SizedBox(height: 8),
                Text(
                  'Due Date',
                  style: TextStyle(
                    fontFamily: 'Arista',
                    color: Colors.black,
                    fontSize: 21,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(1.0),
                  decoration: BoxDecoration(
                    color: Color(0xFFFFA965), // Màu cam
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: ListTile(
                    title: Text(
                      '${DateFormat('dd/MM/yyyy').format(_dueDate)}',
                      style: TextStyle(color: Colors.white, fontFamily: 'KeepCalm'), // Font trắng
                    ),
                    trailing: Icon(Icons.calendar_today, color: Colors.green),
                    onTap: () => _selectDueDate(context),
                  ),
                ),
                const SizedBox(height: 8),


                // Start and End Time
                Text(
                  'Start and End Time',
                  style: TextStyle(
                    fontFamily: 'Arista',
                    color: Colors.black,
                    fontSize: 21,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          color: Color(0xFFFFA965),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: ListTile(
                          title: Text(
                            'Start: ${_startTime.format(context)}',
                            style: TextStyle(color: Colors.white, fontFamily: 'KeepCalm', fontSize: 10),
                          ),
                          trailing: Icon(Icons.access_time, color: Colors.green),
                          onTap: () => _selectTime(context, true),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5), // Khoảng cách giữa hai khung
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          color: Color(0xFFFFA965),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: ListTile(
                          title: Text(
                            'End: ${_endTime.format(context)}',
                            style: TextStyle(color: Colors.white, fontFamily: 'KeepCalm', fontSize: 11),
                          ),
                          trailing: Icon(Icons.access_time, color: Colors.green),
                          onTap: () => _selectTime(context, false),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),


                // Priority dropdown
                Text(
                  'Priority',
                  style: TextStyle(
                    fontFamily: 'Arista', // Set font to Arista
                    color: Colors.black,
                    fontSize: 21,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFFFA965),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  value: _priority,
                  hint: Text('Select Priority', style: TextStyle(color: Colors.orange)),
                  dropdownColor: Color(0xFFFFA965), // Đặt màu cho menu dropdown
                  items: [
                    DropdownMenuItem(child: Text('Quan trọng', style: TextStyle(color: Colors.white)), value: 'Quan trọng'),
                    DropdownMenuItem(child: Text('Bình thường', style: TextStyle(color: Colors.white)), value: 'Bình thường'),
                    DropdownMenuItem(child: Text('Thường', style: TextStyle(color: Colors.white)), value: 'Thường'),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _priority = value;
                    });
                  },
                ),
                const SizedBox(height: 16),


                // Recurring switch
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recurring Event',
                      style: TextStyle(
                        fontFamily: 'Arista', // Set font to Arista
                        color: Colors.black,
                          fontSize: 21
                      ),
                    ),
                    Switch(
                      value: _recurring,
                      onChanged: (value) {
                        setState(() {
                          _recurring = value;
                        });
                      },
                      activeColor: Colors.green,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Submit button
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text(
                    'Save Event',
                    style: TextStyle(
                      fontFamily: 'KeepCalm', // Set font to KeepCalm
                      fontSize: 18,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
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
