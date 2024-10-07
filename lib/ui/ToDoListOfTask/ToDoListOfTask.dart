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
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  DateTime _dueDate = DateTime.now();
  TimeOfDay _time = TimeOfDay(hour: 9, minute: 0);
  String? _level;
  final TaskService _taskService = TaskService();

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
        final now = DateTime.now();
        final taskDateTime = DateTime(now.year, now.month, now.day, _time.hour, _time.minute);
        String formattedTime = DateFormat('HH:mm:ss').format(taskDateTime);

        TaskCreateRequestModel newTask = TaskCreateRequestModel(
          title: _titleController.text,
          description: _descriptionController.text,
          priority: _level!,
          dueDate: DateFormat('yyyy-MM-dd').format(_dueDate),
          timeTask: formattedTime,
        );

        bool success = await _taskService.createTask(newTask, token);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? 'Tạo nhiệm vụ thành công!' : 'Tạo nhiệm vụ thất bại.'),
          ),
        );

        if (success) {
          Navigator.pop(context, true);
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
      backgroundColor: Color(0xFFFFE29A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                _buildHeader(),
                const SizedBox(height: 16),
                _buildTextField('Title', _titleController, 'Title of task', 'Please enter a title'),
                const SizedBox(height: 16),
                _buildTextField('Description', _descriptionController, 'Content', null, maxLines: 3),
                const SizedBox(height: 16),
                _buildDatePicker(),
                const SizedBox(height: 16),
                _buildTimePicker(),
                const SizedBox(height: 16),
                _buildLevelDropdown(),
                const SizedBox(height: 24),
                _buildConfirmButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
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
            fontFamily: 'Arista',
            fontSize: 35.0,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String hint, String? errorText, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Arista',
            fontSize: 25,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white, fontFamily: 'KeepCalm'),
            filled: true,
            fillColor: Color(0xFFFFA965),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide.none,
            ),
          ),
          validator: (value) => (errorText != null && (value == null || value.isEmpty)) ? errorText : null,
          style: TextStyle(fontFamily: 'Arista'),
        ),
      ],
    );
  }

  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Due Date',
          style: TextStyle(fontFamily: 'Arista', fontSize: 25, color: Colors.black),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _selectDueDate(context),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFFFFA965),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: ListTile(
              title: Text(
                '${DateFormat('dd/MM/yyyy').format(_dueDate)}',
                style: TextStyle(fontFamily: 'KeepCalm', color: Colors.white),
              ),
              trailing: Icon(Icons.calendar_today, color: Colors.green),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Time',
          style: TextStyle(fontFamily: 'Arista', fontSize: 25, color: Colors.black),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _selectTime(context),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFFFFA965),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: ListTile(
              title: Text(
                '${_time.format(context)}',
                style: TextStyle(fontSize: 15, fontFamily: 'KeepCalm', color: Colors.white),
              ),
              trailing: Icon(Icons.access_time, color: Colors.green),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLevelDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Level',
          style: TextStyle(fontFamily: 'Arista', fontSize: 25, color: Colors.black),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _level,
          items: ['Quan trọng', 'Bình thường', 'Thường']
              .map((level) => DropdownMenuItem(
            child: Text(level, style: TextStyle(fontFamily: 'Arista', color: Colors.white)),
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
          validator: (value) => (value == null) ? 'Please select a level' : null,
          style: TextStyle(fontFamily: 'Arista', color: Colors.white),
          dropdownColor: Color(0xFFFFA965),
        ),
      ],
    );
  }

  Widget _buildConfirmButton() {
    return Center(
      child: ElevatedButton(
        onPressed: _createNewTask,
        child: Text('Xác nhận', style: TextStyle(fontFamily: 'Arista')),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFFFA965),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        ),
      ),
    );
  }
}