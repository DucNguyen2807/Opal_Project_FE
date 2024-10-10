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
        weekendTextStyle: const TextStyle(
          color: Colors.red,
          fontFamily: 'KeepCalm', // Font for numbers (weekends)
        ),
        defaultTextStyle: const TextStyle(
          color: Colors.black,
          fontFamily: 'KeepCalm', // Font for numbers (weekdays)
        ),
        todayTextStyle: const TextStyle(
          color: Colors.white,
          fontFamily: 'KeepCalm', // Font for today's date
        ),
        selectedTextStyle: const TextStyle(
          color: Colors.white,
          fontFamily: 'KeepCalm', // Font for selected date
        ),
      ),
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: const TextStyle(
          fontSize: 24,
          color: Color(0xFF7EBB42),
          fontFamily: 'KeepCalm', // Font for month title
        ),
        leftChevronIcon: const Icon(Icons.chevron_left, color: Color(0xFF7EBB42)),
        rightChevronIcon: const Icon(Icons.chevron_right, color: Color(0xFF7EBB42)),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: const TextStyle(
          color: Color(0xFF7EBB42),
          fontSize: 15,
          fontFamily: 'Arista', // Font for day names (weekdays)
        ),
        weekendStyle: const TextStyle(
          color: Color(0xFF7EBB42),
          fontFamily: 'Arista', // Font for day names (weekends)
          fontSize: 15,

        ),
        dowTextFormatter: (date, locale) {
          List<String> dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
          return dayNames[date.weekday % 7];
        },
      ),
      daysOfWeekHeight: 40, // Adjust this height to create more space for the day names
    );
  }
}
