import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddNewTaskPage extends StatefulWidget {
  final DateTime selectedDate;

  AddNewTaskPage({required this.selectedDate});

  @override
  _AddNewTaskPageState createState() => _AddNewTaskPageState();
}

class _AddNewTaskPageState extends State<AddNewTaskPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  DateTime _dueDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = TimeOfDay(hour: 17, minute: 0);
  String? _level;

  // Function to select a due date
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

  // Function to select a time
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFE29A), // Light yellow background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                // Header with back button and title
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.green),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(width: 50),
                    Text(
                      'ADD NEW EVENT',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

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

                // Description input
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

                // Due date selection
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
                  'Level',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _level,
                  items: ['Quan trọng', 'Bình thường', 'Thường']
                      .map((level) => DropdownMenuItem(
                    child: Text(level),
                    value: level,
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
                      _level = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a level';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Submit button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Handle form submission here
                      }
                    },
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
