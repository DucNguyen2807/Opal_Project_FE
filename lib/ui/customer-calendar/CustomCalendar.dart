import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:opal_project/services/CustomizeService/CustomizeService.dart'; // Import CustomizeService để gọi API

class CustomCalendar extends StatefulWidget {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final CalendarFormat calendarFormat;
  final void Function(DateTime, DateTime) onDaySelected;
  final void Function(CalendarFormat) onFormatChanged;

  CustomCalendar({
    required this.focusedDay,
    required this.selectedDay,
    required this.calendarFormat,
    required this.onDaySelected,
    required this.onFormatChanged,
  });

  @override
  _CustomCalendarState createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  Map<String, dynamic>? _customizationData; // Dữ liệu từ API
  bool _isLoading = true; // Hiển thị trạng thái chờ

  @override
  void initState() {
    super.initState();
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
    Color fontColor = Color(int.parse(_customizationData!['fontColor'].substring(2), radix: 16) + 0xFF000000); // Lấy fontColor từ API

    return TableCalendar(
      focusedDay: widget.focusedDay,
      firstDay: DateTime(2020),
      lastDay: DateTime(2050),
      calendarFormat: widget.calendarFormat,
      selectedDayPredicate: (day) {
        return isSameDay(widget.selectedDay, day);
      },
      onDaySelected: widget.onDaySelected,
      onFormatChanged: widget.onFormatChanged,
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          color: Colors.orangeAccent,
          borderRadius: BorderRadius.circular(12),
        ),
        selectedDecoration: BoxDecoration(
          color: Colors.greenAccent,
          borderRadius: BorderRadius.circular(12),
        ),
        defaultDecoration: BoxDecoration(
          color: Color(0xFFF8F1FF),
          borderRadius: BorderRadius.circular(12),
        ),
        outsideDecoration: BoxDecoration(
          color: Color(0xFFF0E9F6),
          borderRadius: BorderRadius.circular(12),
        ),
        weekendDecoration: BoxDecoration(
          color: Color(0xFFF8F1FF),
          borderRadius: BorderRadius.circular(12),
        ),
        weekendTextStyle: TextStyle(
          color: Colors.red,
          fontFamily: font2, // Áp dụng font2 từ API
        ),
        defaultTextStyle: TextStyle(
          color: Colors.black,
          fontFamily: font2, // Áp dụng font2 từ API
        ),
        todayTextStyle: TextStyle(
          color: Colors.white,
          fontFamily: font2, // Áp dụng font2 từ API
        ),
        selectedTextStyle: TextStyle(
          color: Colors.white,
          fontFamily: font2, // Áp dụng font2 từ API
        ),
      ),
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: TextStyle(
          fontSize: 24,
          color: fontColor, // Sử dụng fontColor từ API
          fontFamily: font2, // Áp dụng font2 từ API
        ),
        leftChevronIcon: Icon(Icons.chevron_left, color: fontColor), // Sử dụng fontColor từ API
        rightChevronIcon: Icon(Icons.chevron_right, color: fontColor), // Sử dụng fontColor từ API
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(
          color: fontColor, // Sử dụng fontColor từ API
          fontSize: 15,
          fontFamily: font1, // Áp dụng font1 từ API
        ),
        weekendStyle: TextStyle(
          color: fontColor, // Sử dụng fontColor từ API
          fontFamily: font1, // Áp dụng font1 từ API
          fontSize: 15,
        ),
        dowTextFormatter: (date, locale) {
          List<String> dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
          return dayNames[date.weekday % 7];
        },
      ),
      daysOfWeekHeight: 40, // Điều chỉnh khoảng cách giữa tên ngày
    );
  }
}
