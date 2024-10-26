import 'package:opal_project/services/Config/config.dart';
import 'package:flutter/material.dart';
import 'package:opal_project/ui/customer-calendar/CustomCalendar.dart';
import 'package:opal_project/ui/ToDoListOfTask/ToDoListOfTask.dart';
import 'dart:collection';
import 'package:table_calendar/table_calendar.dart';
import 'package:opal_project/services/TaskService/TaskService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:opal_project/services/CustomizeService/CustomizeService.dart';
import 'package:opal_project/services/ThemeService/ThemeService.dart';

class ToDoListPage extends StatefulWidget {
  @override
  _ToDoListPageState createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  LinkedHashMap<DateTime, List<Map<String, dynamic>>> _events = LinkedHashMap();
  late TaskService _taskService;
  bool _isLoading = false;
  Map<String, dynamic>? _customizationData;
  Map<String, dynamic>? _themeData;
  // Màu đồng bộ
  final Color primaryColor = Color(0xFFFFA965);
  final Color secondaryColor = Color(0xFFFFA965);
  final Color completedTaskColor = Color(0xFFFCE4EC);



  @override
  void initState() {
    super.initState();
    _taskService = TaskService();
    _fetchTheme();
    _selectedDay = DateTime.now();
    _fetchCustomization();
    _loadTasksForSelectedDay();
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


  Future<void> _loadTasksForSelectedDay() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      if (token.isNotEmpty && _selectedDay != null) {
        final tasks = await _taskService.getTasksByDate(_selectedDay!, token);
        setState(() {
          _events[_selectedDay!] = tasks;
        });
      }
    } catch (e) {
      print('Error fetching tasks: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> _layCongViecChoNgay(DateTime day) {
    return _events[day] ?? [];
  }


  @override
  Widget build(BuildContext context) {
    String font1 = _customizationData?['font1'] ?? 'Arista';
    String font2 = _customizationData?['font2'] ?? 'KeepCalm';

    String backGroundImg = _themeData?['icon2'] ?? '';

    Color backgroundColor = _customizationData?['uiColor'] != null
        ? Color(
        int.parse(_customizationData!['uiColor'].substring(2), radix: 16) +
            0xFF000000)
        : Colors.white; // Màu mặc định nếu ui_color là null
    Color textBoxColor = _customizationData?['textBoxColor'] != null
        ? Color(
        int.parse(_customizationData!['textBoxColor'].substring(2), radix: 16) +
            0xFF000000)
        : Colors.white;
    Color buttonColor = _customizationData?['buttonColor'] != null
        ? Color(
        int.parse(_customizationData!['buttonColor'].substring(2), radix: 16) +
            0xFF000000)
        : Colors.green;
    Color fontColor = _customizationData?['fontColor'] != null
        ? Color(
        int.parse(_customizationData!['fontColor'].substring(2), radix: 16) +
            0xFF000000)
        : Colors.green;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor, // Sử dụng màu nền chính
        elevation: 0, // Xóa bóng của AppBar
        centerTitle: true, // Căn giữa tiêu đề trực tiếp
        title: Text(
          'To Do List',
          style: TextStyle(
            color: fontColor, // Màu chữ của tiêu đề
            fontSize: 30, // Kích thước chữ
            fontWeight: FontWeight.bold, // Độ đậm của chữ
          ),
        ),
      ),
      body: Stack(
        children: [
          // Ảnh nền, hiển thị nếu `backGroundImg` có giá trị
          if (backGroundImg.isNotEmpty)
            Positioned.fill(
              child: Image.asset(
                backGroundImg,
                fit: BoxFit.cover,
              ),
            ),

          // Nội dung chính
          SafeArea(
            child: Column(
              children: [
                _xayDungLich(),
                const SizedBox(height: 16),
                Expanded(
                  child: _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : _xayDungDanhSachCongViec(textBoxColor),
                ),
                _xayDungThanhCongCuDuoi(),
              ],
            ),
          ),
        ],
      ),
    );

  }

    Widget _xayDungLich() {
    return CustomCalendar(
      focusedDay: _focusedDay,
      selectedDay: _selectedDay,
      calendarFormat: _calendarFormat,
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
        _loadTasksForSelectedDay();
      },
      onFormatChanged: (format) {},
    );
  }

  Widget _xayDungDanhSachCongViec(Color textBoxColor) {
    List<Map<String, dynamic>> congViecChoNgay = _layCongViecChoNgay(_selectedDay ?? DateTime.now());

    if (congViecChoNgay.isEmpty) {
      return Center(child: Text('Không có công việc cho ngày này.'));
    }

    return ListView.builder(
      itemCount: congViecChoNgay.length,
      itemBuilder: (context, index) {
        final task = congViecChoNgay[index];

        return Dismissible(
          key: Key(task['taskId'] ?? index.toString()),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.redAccent,
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (direction) async {
            if (task['taskId'] != null && task['taskId'] is String) {
              try {
                final prefs = await SharedPreferences.getInstance();
                final token = prefs.getString('token') ?? '';
                if (token.isNotEmpty) {
                  bool success = await _taskService.deleteTask(task['taskId'], token);
                  if (success) {
                    setState(() {
                      congViecChoNgay.removeAt(index);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Task đã được xóa thành công.')),
                    );
                  }
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Xóa task thất bại.')),
                );
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Task ID không khả dụng.')),
              );
            }
          },
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              // Logic khác khi nhấn vào item (nếu cần)
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Hiển thị thời gian ở bên trái ngoài khung
                  Column(
                    children: [
                      Text(
                        task['time'],
                        style: TextStyle(
                          color: textBoxColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: task['isCompleted'] ? completedTaskColor : Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 6,
                            spreadRadius: 2,
                          ),
                        ],
                        border: Border(
                          left: BorderSide(
                            color: _getPriorityColor(task['priority']), // Sử dụng hàm để lấy màu sắc ưu tiên
                            width: 5,
                          ),
                        ),
                      ),
                      constraints: BoxConstraints(
                        minHeight: 80, // Đặt chiều cao tối thiểu cho khung
                        maxWidth: 250, // Giới hạn độ rộng
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Nội dung task
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  task['title'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  task['description'],
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          // Nút kiểm tra trạng thái hoàn thành
                          IconButton(
                            icon: task['isCompleted']
                                ? Icon(Icons.check_circle, color: Colors.greenAccent, size: 28)
                                : Icon(Icons.radio_button_unchecked, color: secondaryColor, size: 28),
                            onPressed: () async {
                              if (task['taskId'] != null && task['taskId'] is String) {
                                try {
                                  final prefs = await SharedPreferences.getInstance();
                                  final token = prefs.getString('token') ?? '';
                                  if (token.isNotEmpty) {
                                    bool success = await _taskService.toggleTaskCompletion(task['taskId'], token);
                                    if (success) {
                                      setState(() {
                                        task['isCompleted'] = !task['isCompleted'];
                                      });

                                    }
                                  }
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Cập nhật trạng thái task thất bại.')),
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Task ID không khả dụng.')),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );


  }





  Widget _xayDungThanhCongCuDuoi() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
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
            icon: Icon(Icons.add_circle, color: primaryColor),
            iconSize: 80,
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddNewTaskPage1(
                    selectedDate: _selectedDay ?? DateTime.now(),
                  ),
                ),
              );
              if (result == true) {
                // Nếu tạo công việc thành công, cập nhật lại danh sách
                _loadTasksForSelectedDay();
              }
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
        ],
      ),
    );
  }
  Color _getPriorityColor(String priority) {
    String normalizedPriority = priority.toLowerCase().trim();

    switch (normalizedPriority) {
      case 'quan trọng':
      case 'quan trọng':
        return Colors.red;
      case 'bình thường':
      case 'bình thường':
        return Colors.blue;
      case 'thường':
      case 'thường':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

}