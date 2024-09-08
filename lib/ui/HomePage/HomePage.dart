import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:collection';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  LinkedHashMap<DateTime, List<String>> _events = LinkedHashMap();
  bool isWeekView = false; // Variable to toggle between month/week view

  List<String> _layCongViecChoNgay(DateTime day) {
    return _events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCE6A4),
      body: SafeArea(
        child: Column(
          children: [
            _xayDungTieuDe(),
            _xayDungNutChuyenDoi(), // Toggle button for week/month view
            _xayDungLich(),
            const SizedBox(height: 8),
            _xayDungThanhCongCuDuoi(),
          ],
        ),
      ),
    );
  }

  // Header with "June 2024", user avatar, etc.
  Widget _xayDungTieuDe() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    isWeekView = true;
                    _calendarFormat = CalendarFormat.week;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Color(0xFFF58282), // Background color for the button
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "7",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8), // Space between the two buttons
              // GestureDetector to detect taps on the "30" button for Month view
              GestureDetector(
                onTap: () {
                  setState(() {
                    isWeekView = false;
                    _calendarFormat = CalendarFormat.month;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Color(0xFFFFB74D), // Background color for the button
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "30",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Logo at the center
          Image.asset(
            'assets/logo.png', // Your logo image path here
            height: 120,
          ),
          // Avatar on the right side
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.yellowAccent,
            child: Icon(Icons.person), // Placeholder for the avatar
          ),
        ],
      ),
    );
  }


  // Toggle button for switching between Month and Week views
  Widget _xayDungNutChuyenDoi() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                isWeekView = !isWeekView;
                _calendarFormat = isWeekView ? CalendarFormat.week : CalendarFormat.month;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.purple[200],
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Text(
                isWeekView ? 'Month' : 'Week', // Display the toggle option
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }




  // Build the calendar with styles
  Widget _xayDungLich() {
    return Column(
      children: [
        TableCalendar(
          focusedDay: _focusedDay,
          firstDay: DateTime(2020),
          lastDay: DateTime(2050),
          calendarFormat: _calendarFormat,
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          onFormatChanged: (format) {
            if (_calendarFormat != format) {
              setState(() {
                _calendarFormat = format;
              });
            }
          },
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: Colors.orangeAccent,
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: Colors.greenAccent,
              shape: BoxShape.circle,
            ),
            defaultDecoration: BoxDecoration(
              color: Color(0xFFF8F1FF),
              borderRadius: BorderRadius.circular(8),
            ),
            outsideDecoration: BoxDecoration(
              color: Color(0xFFF0E9F6),
              borderRadius: BorderRadius.circular(8),
            ),
            weekendDecoration: BoxDecoration(
              color: Color(0xFFF8F1FF),
              borderRadius: BorderRadius.circular(8),
            ),
            weekendTextStyle: TextStyle(color: Colors.red),
            defaultTextStyle: TextStyle(color: Colors.black),
          ),
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: TextStyle(fontSize: 24, color: Color(0xFF7EBB42)),
            leftChevronIcon: Icon(Icons.chevron_left, color: Color(0xFF7EBB42)),
            rightChevronIcon: Icon(Icons.chevron_right, color: Color(0xFF7EBB42)),
          ),
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: TextStyle(color: Colors.black),  // Màu chữ của ngày thường
            weekendStyle: TextStyle(color: Colors.redAccent),  // Màu chữ của cuối tuần
            dowTextFormatter: (date, locale) {
              // Danh sách tên ngày tùy chỉnh (Sun, Mon, Tue,...)
              List<String> dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
              return dayNames[date.weekday % 7];  // Lấy tên ngày từ danh sách
            },
          ),
          daysOfWeekHeight: 40, // Chiều cao của hàng ngày trong tuần
        ),
        const SizedBox(height: 16),
        _xayDungDanhSachCongViec(), // Add the task list here
      ],
    );
  }



// Build the task list for the selected day
  Widget _xayDungDanhSachCongViec() {
    List<String> congViecChoNgay = _layCongViecChoNgay(_selectedDay ?? DateTime.now());

    if (congViecChoNgay.isEmpty) {
      return Text('Không có công việc cho ngày này.');
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: congViecChoNgay.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(congViecChoNgay[index]),
          leading: Icon(Icons.task_alt),
        );
      },
    );
  }


  // Bottom toolbar with icons
  Widget _xayDungThanhCongCuDuoi() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,  // Đẩy xuống dưới
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Image.asset(
                  'assets/icon opal-01.png',
                  width: 54,
                  height: 54,
                ),
                onPressed: () {
                  // Xử lý sự kiện khi nhấn nút
                },
              ),
              IconButton(
                icon: Image.asset(
                  'assets/icon opal-07.png',
                  width: 54,
                  height: 54,
                ),
                onPressed: () {
                  // Xử lý sự kiện khi nhấn nút
                },
              ),
              IconButton(
                icon: Image.asset(
                  'assets/icon opal-08.png',
                  width: 54,
                  height: 54,
                ),
                onPressed: () {
                  // Xử lý sự kiện khi nhấn nút
                },
              ),
              IconButton(
                icon: Image.asset(
                  'assets/icon opal-09.png',
                  width: 54,
                  height: 54,
                ),
                onPressed: () {
                  // Xử lý sự kiện khi nhấn nút
                },
              ),
              IconButton(
                icon: Icon(Icons.settings, color: Colors.green),
                iconSize: 50, // Tăng kích thước của nút cuối cùng
                onPressed: () {
                  // Xử lý sự kiện khi nhấn nút
                },
              ),
            ],
          ),
        ],
      ),
    );
  }


}
