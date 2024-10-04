import 'package:flutter/material.dart';
import 'package:opal_project/ui/FeedBird/FeedBird.dart';
import 'package:opal_project/ui/customer-calendar/CustomCalendar.dart';
import 'dart:collection';
import 'package:table_calendar/table_calendar.dart';
import 'package:opal_project/ui/EventPage/EventPage.dart';
import 'package:opal_project/ui/my-task/mytask.dart';
import 'package:opal_project/ui/settings/settings.dart';
import 'package:opal_project/ui/CustomBottomBar/CustomBottomBar.dart';

import '../ToDoListPage/ToDoListPage.dart';

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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _xayDungTieuDe(),
            _xayDungNutChuyenDoi(),
            _xayDungLich(),
            const SizedBox(height: 8),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        onFirstButtonPressed: () {
          // Handle first button press
        },
        onSecondButtonPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ToDoListPage()),
          );
        },
        onEventButtonPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventPage(selectedDate: _selectedDay ?? DateTime.now()), // Truyền selectedDate
            ),
          );
        },
        onFourthButtonPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FeedBird(), // Truyền selectedDate
            ),
          );
        },
        onSettingsButtonPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SettingsScreen()),
          );
        },
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
                    " 7 ",
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
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MytaskScreen()),
              );
            },
            child: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.yellowAccent,
              child: Icon(Icons.person),
            ),
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
}