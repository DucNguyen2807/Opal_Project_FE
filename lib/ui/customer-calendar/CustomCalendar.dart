import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomCalendar extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return TableCalendar(
      focusedDay: focusedDay,
      firstDay: DateTime(2020),
      lastDay: DateTime(2050),
      calendarFormat: calendarFormat,
      selectedDayPredicate: (day) {
        return isSameDay(selectedDay, day);
      },
      onDaySelected: onDaySelected,
      onFormatChanged: onFormatChanged,
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
        weekdayStyle: TextStyle(
          color: Color(0xFF7EBB42),
          fontWeight: FontWeight.bold,
        ), // Green text for weekdays
        weekendStyle: TextStyle(
          color: Color(0xFF7EBB42),
          fontWeight: FontWeight.bold,
        ), // Green text for weekends
        dowTextFormatter: (date, locale) {
          List<String> dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
          return dayNames[date.weekday % 7];
        },
      ),
      daysOfWeekHeight: 40, // Adjust this height to create more space for the day names
    );
  }
}
