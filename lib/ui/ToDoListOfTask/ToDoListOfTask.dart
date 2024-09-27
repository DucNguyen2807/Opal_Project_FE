import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:opal_project/services/TaskService/TaskService.dart';
import 'package:opal_project/model/TaskCreateRequestModel.dart';

class AddNewTaskPage1 extends StatefulWidget {
  final DateTime selectedDate;

  AddNewTaskPage1({required this.selectedDate});

  @override
  _AddNewTaskPageState1 createState() => _AddNewTaskPageState1();
}

class _AddNewTaskPageState1 extends State<AddNewTaskPage1> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  DateTime _dueDate = DateTime.now();
  TimeOfDay _time = TimeOfDay(hour: 9, minute: 0);
  String? _level;
  TaskService _taskService = TaskService(); // Tạo đối tượng TaskService

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

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (picked != null) {
      setState(() {
        _time = picked;
      });
    }
  }

  Future<void> _createNewTask() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      if (token.isNotEmpty) {
        // Chuyển `TimeOfDay` thành định dạng 24 giờ HH:mm:ss (API chỉ nhận 24 giờ)
        final now = DateTime.now();
        final taskDateTime = DateTime(now.year, now.month, now.day, _time.hour, _time.minute);
        String formattedTime = DateFormat('HH:mm:ss').format(taskDateTime);

        TaskCreateRequestModel newTask = TaskCreateRequestModel(
          title: _titleController.text,
          description: _descriptionController.text,
          priority: _level!,
          dueDate: DateFormat('yyyy-MM-dd').format(_dueDate),
          timeTask: formattedTime,  // Gửi thời gian theo định dạng 24 giờ
        );

        bool success = await _taskService.createTask(newTask, token);

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Tạo nhiệm vụ thành công!')),
          );
          Navigator.pop(context, true);  // Trả về true khi tạo thành công
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Tạo nhiệm vụ thất bại.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Token không hợp lệ')),
        );
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFE29A), // Màu nền toàn màn hình
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
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
                      'ADD NEW TASK',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Tiêu đề (Title)
                Text(
                  'Title',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: 'Title of task',
                    hintStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Color(0xFFFFA965), // Màu cam
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

                // Mô tả (Description)
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
                    fillColor: Color(0xFFFFA965), // Màu cam
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Chọn ngày (Due Date)
                Text(
                  'Due Date',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ListTile(
                  title: Text(
                    '${DateFormat('dd/MM/yyyy').format(_dueDate)}',
                    style: TextStyle(color: Colors.black), // Màu đen
                  ),
                  trailing: Icon(Icons.calendar_today, color: Colors.green),
                  onTap: () => _selectDueDate(context),
                ),
                const SizedBox(height: 16),

                // Chọn thời gian (Time)
                Text(
                  'Time',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ListTile(
                  title: Text(
                    '${_time.format(context)}',
                    style: TextStyle(color: Colors.black), // Màu đen
                  ),
                  trailing: Icon(Icons.access_time, color: Colors.green),
                  onTap: () => _selectTime(context),
                ),
                const SizedBox(height: 16),

                // Mức độ quan trọng (Level)
                Text(
                  'Level',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _level,
                  items: ['Important', 'Normal', 'Remember']
                      .map((level) => DropdownMenuItem(
                    child: Text(level),
                    value: level,
                  ))
                      .toList(),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFFFA965), // Màu cam
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

                // Nút xác nhận
                Center(
                  child: ElevatedButton(
                    onPressed: _createNewTask,
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
                SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
