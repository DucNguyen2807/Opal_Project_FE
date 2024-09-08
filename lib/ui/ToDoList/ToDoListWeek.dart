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

  // Hàm chọn ngày
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

  // Hàm chọn thời gian
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
      backgroundColor: const Color(0xFFFCE6A4),
      appBar: AppBar(
        title: Text('Add New Event'),
        backgroundColor: Colors.greenAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Tiêu đề
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Mô tả
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Chọn ngày
              ListTile(
                title: Text('Due date: ${DateFormat.yMd().format(_dueDate)}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _selectDueDate(context),
              ),
              const SizedBox(height: 16),

              // Chọn thời gian bắt đầu và kết thúc
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: Text('Start: ${_startTime.format(context)}'),
                      trailing: Icon(Icons.access_time),
                      onTap: () => _selectTime(context, true),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ListTile(
                      title: Text('End: ${_endTime.format(context)}'),
                      trailing: Icon(Icons.access_time),
                      onTap: () => _selectTime(context, false),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Mức độ quan trọng
              DropdownButtonFormField<String>(
                value: _level,
                items: ['Important', 'Normal', 'Remember']
                    .map((level) => DropdownMenuItem(
                  child: Text(level),
                  value: level,
                ))
                    .toList(),
                decoration: InputDecoration(
                  labelText: 'Level',
                  border: OutlineInputBorder(),
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

              // Nút xác nhận
              ElevatedButton(
                onPressed: () {
                  // Hành động khi bấm nút
                },
                child: Text('Xác nhận'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent, // Đúng
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
