import 'package:flutter/material.dart';
import 'package:opal_project/ui/customer-calendar/CustomCalendar.dart';
import 'package:opal_project/ui/ToDoList/ToDoListWeek.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../services/EventService/EventService.dart';

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

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.selectedDate;
    _fetchEvents(_selectedDay!);
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
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Event Page'),
        backgroundColor: Color(0xFFFFA965),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
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
        backgroundColor: Colors.green,
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
