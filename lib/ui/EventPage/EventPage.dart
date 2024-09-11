import 'package:flutter/material.dart';
import 'package:opal_project/ui/customer-calendar/CustomCalendar.dart'; // Import widget lịch dùng chung
import 'package:opal_project/ui/ToDoList/ToDoListWeek.dart';
import 'package:table_calendar/table_calendar.dart';

class EventPage extends StatefulWidget {
  final DateTime selectedDate;

  EventPage({required this.selectedDate});

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCE6A4),
      appBar: AppBar(
        title: Text('Event Page'),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Quay lại trang trước
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Sử dụng widget lịch dùng chung
            CustomCalendar(
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
                setState(() {
                  _calendarFormat = format;
                });
              },
            ),
            const SizedBox(height: 16),
            _xayDungDanhSachCongViec(), // Danh sách công việc theo ngày
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddNewTaskPage(selectedDate: _selectedDay ?? DateTime.now()),
            ),
          );
        },
      ),
    );
  }

  // Xây dựng danh sách công việc
  Widget _xayDungDanhSachCongViec() {
    return Text('Danh sách công việc cho ngày được chọn');
  }
}
