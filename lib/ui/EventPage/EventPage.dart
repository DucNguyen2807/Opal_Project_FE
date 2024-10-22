import 'package:flutter/material.dart';
import 'package:opal_project/ui/customer-calendar/CustomCalendar.dart';
import 'package:opal_project/ui/ToDoList/ToDoListWeek.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../services/EventService/EventService.dart';
import 'package:opal_project/services/CustomizeService/CustomizeService.dart';
import 'package:opal_project/services/ThemeService/ThemeService.dart';

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
  List<Map<String, dynamic>> _events = [];
  bool _isLoading = true;
  Map<String, dynamic>? _customizationData;
  Map<String, dynamic>? _themeData;
  @override
  void initState() {
    super.initState();
    _selectedDay = widget.selectedDate;
    _fetchEvents(_selectedDay!);
    _fetchCustomization();
    _fetchTheme();

  }
  Future<void> _fetchTheme() async {
    try {
      Themeservice themeService = Themeservice();
      final data = await themeService.getCustomizeByUser();
      setState(() {
        _themeData = data;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching customization: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }
  Future<void> _fetchCustomization() async {
    try {
      CustomizeService customizeService = CustomizeService();
      final data = await customizeService.getCustomizeByUser();
      setState(() {
        _customizationData = data;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching customization: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }
  Future<void> _fetchEvents(DateTime date) async {
    setState(() {
      _isLoading = true;
    });

    final eventService = EventService();
    try {
      final events = await eventService.getEventsByDate(date);
      setState(() {
        _events = events;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching events: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể tải sự kiện: $e')),
      );
    }
  }

  Future<void> _deleteEvent(String eventId, int index) async {
    try {
      await EventService().deleteEvent(eventId);
      setState(() {
        _events.removeAt(index);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sự kiện đã được xoá')),
      );
    } catch (e) {
      print('Error deleting event: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể xoá sự kiện: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    String backGroundImg = _themeData?['icon14'] ?? '';
    Color backgroundColor = _customizationData?['uiColor'] != null
        ? Color(int.parse(_customizationData!['uiColor'].substring(2), radix: 16) + 0xFF000000)
        : Colors.white; // Màu mặc định nếu ui_color là null
    Color buttonColor = _customizationData?['buttonColor'] != null
        ? Color(int.parse(_customizationData!['buttonColor'].substring(2), radix: 16) + 0xFF000000)
        : Colors.green;
    Color fontColor = _customizationData?['fontColor'] != null
        ? Color(int.parse(_customizationData!['fontColor'].substring(2), radix: 16) + 0xFF000000)
        : Colors.green;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor, // Màu nền của AppBar
        title: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(right: 60.0),// Căn giữa tiêu đề
          child: Text(
            'Event Page', // Tiêu đề
            style: TextStyle(
              color: fontColor, // Màu chữ
              fontSize: 30, // Kích thước chữ
              fontWeight: FontWeight.bold, // Độ đậm của chữ
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Nút quay lại
          onPressed: () => Navigator.pop(context), // Hành động quay lại
        ),
      ),
      body: SafeArea(
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
                _fetchEvents(selectedDay);
              },
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
            ),
            const SizedBox(height: 16),
            _isLoading
                ? CircularProgressIndicator()
                : _events.isEmpty
                ? Text('No events for this date')
                : _buildEventList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: buttonColor,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AddNewEventPage(selectedDate: _selectedDay ?? DateTime.now()),
            ),
          ).then((value) {
            _fetchEvents(_selectedDay!);
          });
        },
      ),
    );
  }

  Widget _buildEventList() {
    return Expanded(
      child: ListView.builder(
        itemCount: _events.length,
        itemBuilder: (context, index) {
          final event = _events[index];
          final eventId = event['eventId'];

          return Dismissible(
            key: Key(eventId),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(Icons.delete, color: Colors.white),
            ),
            confirmDismiss: (direction) async {
              return await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Xoá Sự Kiện'),
                  content: Text('Bạn có chắc chắn muốn xoá sự kiện này?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text('Hủy'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text('Xoá'),
                    ),
                  ],
                ),
              );
            },
            onDismissed: (direction) async {
              await _deleteEvent(eventId, index);
            },
            child: _buildTaskItem(
              event['eventTitle'],
              event['eventDescription'] ?? 'Unknown Description',
              _formatEventTime(event['startTime'], event['endTime']),
              event['priority'] ?? 'bình thường',
            ),
          );
        },
      ),
    );
  }

  String _formatEventTime(String startTime, String endTime) {
    final start = DateTime.parse(startTime);
    final end = DateTime.parse(endTime);
    return '${start.hour}:${start.minute.toString().padLeft(2, '0')} - ${end.hour}:${end.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildTaskItem(String title, String location, String time, String priority) {
    Color iconColor = _getPriorityColor(priority);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 4,
        child: ListTile(
          title: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4),
              Text(location),
              SizedBox(height: 4),
              Text(time),
            ],
          ),
          leading: Icon(Icons.event, color: iconColor),
          trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    String normalizedPriority = priority.toLowerCase().trim();

    switch (normalizedPriority) {
      case 'quan trọng':
      case 'quan trọng':
        return Colors.red;
      case 'bình thường':
      case 'bình thường':
        return Colors.blue;
      case 'thường':
      case 'thường':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
