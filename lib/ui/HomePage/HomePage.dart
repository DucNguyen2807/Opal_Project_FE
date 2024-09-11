import 'package:flutter/material.dart';
import 'package:opal_project/ui/customer-calendar/CustomCalendar.dart';
import 'dart:collection';
import 'package:table_calendar/table_calendar.dart';
import 'package:opal_project/ui/EventPage/EventPage.dart';
import 'package:opal_project/ui/ToDoListPage/ToDoListPage.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  LinkedHashMap<DateTime, List<String>> _events = LinkedHashMap();
  bool isWeekView = false;

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
            _xayDungNutChuyenDoi(),
            _xayDungLich(),
            const SizedBox(height: 8),
            _xayDungThanhCongCuDuoi(),
          ],
        ),
      ),
    );
  }

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
                    color: Color(0xFFF58282),
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
              const SizedBox(height: 8),
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
                    color: Color(0xFFFFB74D),
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
          Image.asset(
            'assets/logo.png',
            height: 120,
          ),
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.yellowAccent,
            child: Icon(Icons.person),
          ),
        ],
      ),
    );
  }

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
                isWeekView ? 'Month' : 'Week',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _xayDungLich() {
    return Column(
      children: [
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
            if (_calendarFormat != format) {
              setState(() {
                _calendarFormat = format;
              });
            }
          },
        ),
        const SizedBox(height: 16),
        _xayDungDanhSachCongViec(),
      ],
    );
  }

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



  Widget _xayDungThanhCongCuDuoi() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
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
                onPressed: () {},
              ),
              IconButton(
                icon: Image.asset(
                  'assets/icon opal-07.png',
                  width: 54,
                  height: 54,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ToDoListPage()),
                  );
                },
              ),
              IconButton(
                icon: Image.asset(
                  'assets/icon opal-08.png',
                  width: 54,
                  height: 54,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EventPage(
                        selectedDate: DateTime.now(),
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
              IconButton(
                icon: Icon(Icons.settings, color: Colors.green),
                iconSize: 50,
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
