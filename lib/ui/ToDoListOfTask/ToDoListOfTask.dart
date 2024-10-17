import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:opal_project/services/TaskService/TaskService.dart';
import 'package:opal_project/model/TaskCreateRequestModel.dart';
import 'package:opal_project/services/CustomizeService/CustomizeService.dart';
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
  bool _isLoading = false;

  // Thêm biến để lưu dữ liệu tùy chỉnh
  Map<String, dynamic>? _customizationData;

  @override
  void initState() {
    super.initState();
    _fetchCustomization();
  }

  Future<void> _fetchCustomization() async {
    try {
      CustomizeService customizeService = CustomizeService();
      final data = await customizeService.getCustomizeByUser();
      setState(() {
        _customizationData = data;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching customization: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

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
    // Áp dụng font và màu từ API
    String font1 = _customizationData?['font1'] ?? 'Arista';
    String font2 = _customizationData?['font2'] ?? 'KeepCalm';
    Color backgroundColor = _customizationData?['uiColor'] != null
        ? Color(int.parse(_customizationData!['uiColor'].substring(2), radix: 16) + 0xFF000000)
        : Colors.white; // Màu mặc định nếu ui_color là null
    Color textBoxColor = _customizationData?['textBoxColor'] != null
        ? Color(int.parse(_customizationData!['textBoxColor'].substring(2), radix: 16) + 0xFF000000)
        : Colors.white;
    Color buttonColor = _customizationData?['buttonColor'] != null
        ? Color(int.parse(_customizationData!['buttonColor'].substring(2), radix: 16) + 0xFF000000)
        : Colors.green;
    Color fontColor = _customizationData?['fontColor'] != null
        ? Color(int.parse(_customizationData!['fontColor'].substring(2), radix: 16) + 0xFF000000)
        : Colors.green;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                _buildHeader(font1, fontColor),
                const SizedBox(height: 16),
                _buildTextField('Title', _titleController, 'Title of task', 'Please enter a title', font1, font2, textBoxColor),
                const SizedBox(height: 16),
                _buildTextField('Description', _descriptionController, 'Content', null, font1, font2, textBoxColor, maxLines: 3),
                const SizedBox(height: 16),
                _buildDatePicker(textBoxColor, font1, font2),
                const SizedBox(height: 16),
                _buildTimePicker(textBoxColor, font1, font2),
                const SizedBox(height: 16),
                _buildLevelDropdown(font1, font2, textBoxColor),
                const SizedBox(height: 24),
                _buildConfirmButton(buttonColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String font1, Color fontColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back, color: fontColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        SizedBox(width: 50),
        Text(
          'ADD NEW TASK',
          style: TextStyle(
            fontFamily: font1,
            fontSize: 27.0,
            fontWeight: FontWeight.bold,
            color: fontColor,
          ),
        ),
      ],
    );
  }


  Widget _buildTextField(String label, TextEditingController controller, String hint, String? errorText, String font1, String font2, Color textBoxColor, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: font1,
            fontSize: 21,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white, fontFamily: font2),
            filled: true,
            fillColor: textBoxColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide.none,
            ),
          ),
          validator: (value) => (errorText != null && (value == null || value.isEmpty)) ? errorText : null,
          style: TextStyle(fontFamily: font2, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildDatePicker(Color fillColor, String font1, String font2) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Due Date', // Tiêu đề cho ngày
          style: TextStyle(fontFamily: font1, fontSize: 21, color: Colors.black),
        ),
        const SizedBox(height: 5),
        GestureDetector(
          onTap: () => _selectDueDate(context),
          child: Container(
            decoration: BoxDecoration(
              color: fillColor,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: ListTile(
              title: Text(
                '${DateFormat('dd/MM/yyyy').format(_dueDate)}',
                style: TextStyle(fontFamily: font2, color: Colors.white),
              ),
              trailing: Icon(Icons.calendar_today, color: Colors.green),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimePicker(Color fillColor, String font1, String font2) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Time', // Tiêu đề cho thời gian
          style: TextStyle(fontFamily: font1, fontSize: 21, color: Colors.black),
        ),
        const SizedBox(height: 5),
        GestureDetector(
          onTap: () => _selectTime(context),
          child: Container(
            decoration: BoxDecoration(
              color: fillColor,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: ListTile(
              title: Text(
                '${_time.hour}:${_time.minute < 10 ? '0' : ''}${_time.minute}',
                style: TextStyle(fontFamily: font2, color: Colors.white),
              ),
              trailing: Icon(Icons.access_time, color: Colors.green),
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildLevelDropdown(String font1, String font2, Color textBoxColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Priority',
          style: TextStyle(fontFamily: font1, fontSize: 21, color: Colors.black),
        ),
        const SizedBox(height: 5),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            filled: true,
            fillColor: textBoxColor, // Màu nền cho ô dropdown
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide.none,
            ),
          ),
          value: _level,
          hint: Text('Select Priority', style: TextStyle(fontFamily: font2, color: Colors.white)),
          onChanged: (value) {
            setState(() {
              _level = value;
            });
          },
          items: ['Quan trọng', 'Bình Thường', 'Thường']
              .map((level) => DropdownMenuItem(
            value: level,
            child: Text(level, style: TextStyle(fontFamily: font1,color: Colors.white )),
          ))
              .toList(),
          dropdownColor: textBoxColor,
        ),
      ],
    );
  }



  Widget _buildConfirmButton(Color buttonColor) {
    return ElevatedButton(
      onPressed: _createNewTask,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: Text(
          'Confirm',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
}
