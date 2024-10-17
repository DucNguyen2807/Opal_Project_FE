import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:opal_project/ui/FeedBird/FeedBird.dart';
import 'package:opal_project/ui/customer-calendar/CustomCalendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:collection';
import 'package:table_calendar/table_calendar.dart';
import 'package:opal_project/ui/EventPage/EventPage.dart';
import 'package:opal_project/ui/my-task/mytask.dart';
import 'package:opal_project/ui/settings/settings.dart';
import 'package:opal_project/ui/CustomPage/CustomPage.dart';
import 'package:opal_project/ui/CustomBottomBar/CustomBottomBar.dart';
import 'package:opal_project/services/CustomizeService/CustomizeService.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

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
  Map<String, dynamic>? _customizationData;
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    getDeviceToken();
    _fetchCustomization(); // Gọi API khi widget được khởi tạo

  }

  Future<void> _fetchCustomization() async {
    try {
      CustomizeService customizeService = CustomizeService();
      final data = await customizeService.getCustomizeByUser();
      setState(() {
        _customizationData = data; // Lưu dữ liệu từ API
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching customization: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }



  Future<void> getDeviceToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print("Device Token: $token");

    if (token != null) {
      await saveDeviceToken(token);
    }
  }

  Future<void> saveDeviceToken(String token) async {
    final url = Uri.parse('https://opal.io.vn/api/Notification/save_device_token');

    try {
      final prefs = await SharedPreferences.getInstance();
      String? jwtToken = prefs.getString('token');

      if (jwtToken != null) {
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $jwtToken',
          },
          body: json.encode({
            'deviceToken': token,
          }),
        );

        if (response.statusCode == 200) {
          print('Device token saved successfully');
        } else {
          print('Failed to save device token: ${response.body}');
        }
      } else {
        print('JWT Token not found');
      }
    } catch (e) {
      print('Error saving device token: $e');
    }
  }

  List<String> _layCongViecChoNgay(DateTime day) {
    return _events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator()); // Hiển thị loading
    }

    if (_customizationData == null) {
      return Center(child: Text('Failed to load customization'));
    }

    // Áp dụng font và màu từ API
    String font1 = _customizationData!['font1'] ?? 'Arista';
    String font2 = _customizationData!['font2'] ?? 'KeepCalm';
    Color backgroundColor = _customizationData!['uiColor'] != null
        ? Color(int.parse(_customizationData!['uiColor'].substring(2), radix: 16) + 0xFF000000)
        : Colors.white; // Màu mặc định nếu ui_color là null

    void _reloadData() {
      _fetchCustomization(); // Gọi lại phương thức này để tải dữ liệu
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
        child: Column(
          children: [
            _xayDungTieuDe(),
            _xayDungNutChuyenDoi(),
            _xayDungLich(),
            const SizedBox(height: 8),
          ],
        ),
      ),
      ),

      bottomNavigationBar: CustomBottomBar(
        onFirstButtonPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CustomPage()),
          ).then((_) {
            _reloadData(); // Tải lại dữ liệu khi trở lại từ CustomPage
          });
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
              builder: (context) => EventPage(
                  selectedDate: _selectedDay ?? DateTime.now()),
            ),
          );
        },
        onFourthButtonPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FeedBird(),
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
                _calendarFormat =
                isWeekView ? CalendarFormat.week : CalendarFormat.month;
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
    return SingleChildScrollView(
      child: Column(
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
        ],
      ),
    );
  }
}
