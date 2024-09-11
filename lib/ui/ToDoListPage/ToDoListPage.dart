import 'package:flutter/material.dart';
import 'package:opal_project/ui/customer-calendar/CustomCalendar.dart';
import 'package:opal_project/ui/ToDoList/ToDoListWeek.dart';
import 'dart:collection';
import 'package:table_calendar/table_calendar.dart';

class ToDoListPage extends StatefulWidget {
  @override
  _ToDoListPageState createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  // Chỉ sử dụng CalendarFormat.week
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  LinkedHashMap<DateTime, List<String>> _events = LinkedHashMap();

  List<String> _layCongViecChoNgay(DateTime day) {
    return _events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCE6A4),
      appBar: AppBar(
        title: Text('To Do List'),
        backgroundColor: Colors.green,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _xayDungLich(),
            const SizedBox(height: 16),
            Expanded(child: _xayDungDanhSachCongViec()),
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
      },
      onFormatChanged: (format) {
        // Không cần xử lý khi định dạng lịch không thay đổi vì chỉ sử dụng tuần
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
