import 'package:opal_project/services/Config/config.dart';
import 'package:flutter/material.dart';
import 'package:opal_project/ui/customer-calendar/CustomCalendar.dart';
import 'package:opal_project/ui/ToDoList/ToDoListWeek.dart';
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
  LinkedHashMap<DateTime, List<String>> _events = LinkedHashMap();
  late TaskService _taskService;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _taskService = TaskService(Config.baseUrl);
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
          _events[_selectedDay!] = tasks.map<String>((task) => task['title'].toString()).toList();
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

  List<String> _layCongViecChoNgay(DateTime day) {
    return _events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('To Do List'),
        backgroundColor: Colors.greenAccent,
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
      onFormatChanged: (format) {
      },
    );
  }

  Widget _xayDungDanhSachCongViec() {
    List<String> congViecChoNgay = _layCongViecChoNgay(_selectedDay ?? DateTime.now());

    if (congViecChoNgay.isEmpty) {
      return Center(child: Text('Không có công việc cho ngày này.'));
    }

    return ListView.builder(
      itemCount: congViecChoNgay.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(congViecChoNgay[index]),
          leading: Icon(Icons.task_alt),
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
            onPressed: () {
              // Hành động khi nhấn nút
            },
          ),
          IconButton(
            icon: Icon(Icons.add_circle, color: Colors.green),
            iconSize: 50,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddNewTaskPage(
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
            onPressed: () {
              // Hành động khi nhấn nút
            },
          ),
        ],
      ),
    );
  }
}
