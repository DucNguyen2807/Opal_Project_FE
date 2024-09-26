import 'package:opal_project/services/Config/config.dart';
import 'package:flutter/material.dart';
import 'package:opal_project/ui/customer-calendar/CustomCalendar.dart';
import 'package:opal_project/ui/ToDoListOfTask/ToDoListOfTask.dart';
import 'dart:collection';
import 'package:table_calendar/table_calendar.dart';
import 'package:opal_project/services/TaskService/TaskService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ToDoListPage extends StatefulWidget {
  @override
  _ToDoListPageState createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  LinkedHashMap<DateTime, List<Map<String, dynamic>>> _events = LinkedHashMap();
  late TaskService _taskService;
  bool _isLoading = false;

  // Màu đồng bộ
  final Color primaryColor = Colors.green;
  final Color secondaryColor = Colors.orangeAccent;
  final Color completedTaskColor = Color(0xFFFCE4EC);

  @override
  void initState() {
    super.initState();
    _taskService = TaskService();
    _loadTasksForSelectedDay();
  }

  Future<void> _loadTasksForSelectedDay() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      if (token.isNotEmpty && _selectedDay != null) {
        final tasks = await _taskService.getTasksByDate(_selectedDay!, token);
        setState(() {
          _events[_selectedDay!] = tasks;
        });
      }
    } catch (e) {
      print('Error fetching tasks: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> _layCongViecChoNgay(DateTime day) {
    return _events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('To Do List'),
        backgroundColor: primaryColor, // Sử dụng màu chính
      ),
      body: SafeArea(
        child: Column(
          children: [
            _xayDungLich(),
            const SizedBox(height: 16),
            Expanded(child: _isLoading ? Center(child: CircularProgressIndicator()) : _xayDungDanhSachCongViec()),
            _xayDungThanhCongCuDuoi(),
          ],
        ),
      ),
    );
  }

  Widget _xayDungLich() {
    return CustomCalendar(
      focusedDay: _focusedDay,
      selectedDay: _selectedDay,
      calendarFormat: _calendarFormat,
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
        _loadTasksForSelectedDay();
      },
      onFormatChanged: (format) {},
    );
  }

  Widget _xayDungDanhSachCongViec() {
    List<Map<String, dynamic>> congViecChoNgay = _layCongViecChoNgay(_selectedDay ?? DateTime.now());

    if (congViecChoNgay.isEmpty) {
      return Center(child: Text('Không có công việc cho ngày này.'));
    }

    return ListView.builder(
      itemCount: congViecChoNgay.length,
      itemBuilder: (context, index) {
        final task = congViecChoNgay[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Row(
            children: [
              Column(
                children: [
                  Text(
                    task['time'],
                    style: TextStyle(
                      color: secondaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: task['isCompleted'] ? completedTaskColor : Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 6,
                        spreadRadius: 2,
                      ),
                    ],
                    border: Border(
                      left: BorderSide(
                        color: secondaryColor,
                        width: 5,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task['title'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        task['description'],
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                  icon: task['isCompleted']
                      ? Icon(Icons.check_circle, color: Colors.greenAccent, size: 28)
                      : Icon(Icons.radio_button_unchecked, color: secondaryColor, size: 28),
                  onPressed: () async {
                    if (task['taskId'] != null && task['taskId'] is String) {
                      try {
                        final prefs = await SharedPreferences.getInstance();
                        final token = prefs.getString('token') ?? '';
                        if (token.isNotEmpty) {
                          bool success = await _taskService.toggleTaskCompletion(task['taskId'], token);

                          if (success) {
                            setState(() {
                              task['isCompleted'] = !task['isCompleted'];
                            });
                          }
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to update task status.')));
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Task ID is not available.')));
                    }
                  }),
            ],
          ),
        );
      },
    );
  }

  Widget _xayDungThanhCongCuDuoi() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Image.asset(
              'assets/icon opal-01.png',
              width: 54,
              height: 54,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.add_circle, color: primaryColor), // Sử dụng màu chính
            iconSize: 80,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddNewTaskPage1(
                    selectedDate: _selectedDay ?? DateTime.now(),
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: Image.asset(
              'assets/icon opal-09.png',
              width: 54,
              height: 54,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
