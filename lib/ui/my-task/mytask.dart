import 'package:flutter/material.dart';
import 'package:opal_project/services/TaskService/TaskService.dart'; // Import TaskService
import 'package:shared_preferences/shared_preferences.dart'; // Import để lấy token
import 'package:percent_indicator/percent_indicator.dart'; // Import thư viện percent_indicator
import 'package:intl/intl.dart';
import '../CustomBottomBar/CustomBottomBar.dart';
import '../EventPage/EventPage.dart';
import '../FeedBird/FeedBird.dart';
import '../ToDoListPage/ToDoListPage.dart';
import '../settings/settings.dart';
import '../HomePage/HomePage.dart';
import 'package:opal_project/services/CustomizeService/CustomizeService.dart';
import 'package:opal_project/ui/CustomPage/CustomPage.dart';

class MytaskScreen extends StatefulWidget {
  const MytaskScreen({super.key});

  @override
  _MytaskScreenState createState() => _MytaskScreenState();
}

class _MytaskScreenState extends State<MytaskScreen> {
  List<Map<String, dynamic>> tasks = [];
  List<bool> _taskCompletionStatus = [];
  bool isLoading = true;
  late TaskService _taskService;
  late String token;
  String formattedDate = DateFormat('MMMM d').format(DateTime.now());
  Map<String, dynamic>? _customizationData;

  @override
  void initState() {
    super.initState();
    _taskService = TaskService();
    _loadTasks(); // Gọi phương thức để load danh sách task
    _fetchCustomization();

  }

  Future<void> _fetchCustomization() async {
    try {
      CustomizeService customizeService = CustomizeService();
      final data = await customizeService.getCustomizeByUser();
      setState(() {
        _customizationData = data;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching customization: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Phương thức load danh sách task
  Future<void> _loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedToken = prefs.getString('token'); // Xử lý token có thể null
    if (storedToken == null || storedToken.isEmpty) {
      debugPrint('Token is null or empty');
      setState(() {
        isLoading = false; // Dừng loading
      });
      return; // Thoát nếu không có token
    }

    token = storedToken; // Gán token

    try {
      List<Map<String, dynamic>> taskList = await _taskService.getTasksAndPriorityByDate(DateTime.now(), token);

      debugPrint('Task List: $taskList');

      setState(() {
        tasks = taskList;
        _taskCompletionStatus = List<bool>.generate(tasks.length, (index) => tasks[index]['isCompleted'] ?? false);
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading tasks: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _toggleTaskCompletion(int index, String taskId) async {
    try {
      bool success = await _taskService.toggleTaskCompletion(taskId, token);
      debugPrint('Toggle Task Completion for taskId $taskId: $success');

      if (success) {
        setState(() {
          _taskCompletionStatus[index] = !_taskCompletionStatus[index];
          // Tính toán lại tỷ lệ hoàn thành sau khi cập nhật trạng thái
        });
      }
    } catch (e) {
      debugPrint('Error toggling task completion: $e');
    }
  }

// Tính toán tỷ lệ hoàn thành
  double _calculateCompletionRate() {
    int totalTasks = tasks.length; // Tổng số nhiệm vụ
    int completedTasks = _taskCompletionStatus.where((status) => status == true).length; // Nhiệm vụ đã hoàn thành
    return totalTasks > 0 ? completedTasks / totalTasks : 0.0; // Tỷ lệ hoàn thành
  }


  @override
  Widget build(BuildContext context) {
    String font1 = _customizationData?['font1'] ?? 'Arista';
    String font2 = _customizationData?['font2'] ?? 'KeepCalm';
    Color backgroundColor = _customizationData?['uiColor'] != null
        ? Color(int.parse(_customizationData!['uiColor'].substring(2), radix: 16) + 0xFF000000)
        : Colors.white; // Màu mặc định nếu ui_color là null
    Color textBoxColor = _customizationData?['textBoxColor'] != null
        ? Color(int.parse(_customizationData!['textBoxColor'].substring(2), radix: 16) + 0xFF000000)
        : Colors.white;
    Color buttonColor = _customizationData?['buttonColor'] != null
        ? Color(int.parse(_customizationData!['buttonColor'].substring(2), radix: 16) + 0xFF000000)
        : Colors.green;
    Color fontColor = _customizationData?['fontColor'] != null
        ? Color(int.parse(_customizationData!['fontColor'].substring(2), radix: 16) + 0xFF000000)
        : Colors.green;


    double completionRate = _calculateCompletionRate(); // Tính toán tỷ lệ hoàn thành
    int totalTasks = tasks.length; // Tổng số nhiệm vụ
    int completedTasks = _taskCompletionStatus.where((status) => status == true).length;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Hiển thị vòng quay trong khi loading
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      // Điều hướng về trang HomePage
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    },
                    child: Image.asset(
                      'assets/logo.png',
                      width: 150,
                      height: 150,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Hi, Opal',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),
            const Text(
              'Be productive today!!!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            

            Container(
              decoration: BoxDecoration(
                color: textBoxColor, // Màu nền
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Task progress',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '$completedTasks/$totalTasks tasks done',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        Text(
                          formattedDate,
                          style: TextStyle(fontSize: 14, color: fontColor),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),

                  CircularPercentIndicator(
                    radius: 80.0,
                    lineWidth: 10.0,
                    animation: true,
                    percent: completionRate,
                    center: Text(
                      "${(completionRate * 100).toStringAsFixed(1)}%",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    progressColor: Colors.green,
                    backgroundColor: Colors.grey,
                    circularStrokeCap: CircularStrokeCap.round,
                  ),
                ],
              ),
            ),

            const Text(
              'My tasks',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Column(
              children: tasks.isNotEmpty
                  ? tasks.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, dynamic> task = entry.value;

                return _taskItem(task['title'] ?? 'Untitled Task', index, task['taskId'] ?? '');
              }).toList()
                  : [const Text('No tasks available')],
            ),
            const SizedBox(height: 20),

            // Khung màu cam cho biểu đồ hoàn thành

            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        onFirstButtonPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CustomPage()), // Chuyển sang CustomPage
          );
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
            MaterialPageRoute(builder: (context) => EventPage(selectedDate: DateTime.now())),
          );
        },
        onFourthButtonPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FeedBird()),
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


  // Widget cho mỗi task
  Widget _taskItem(String title, int index, String taskId) {
    debugPrint('Task Item: title=$title, index=$index, taskId=$taskId');

    return GestureDetector(
      onTap: () {
        _toggleTaskCompletion(index, taskId);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color: _taskCompletionStatus[index] ? Colors.green : Colors.grey),
        ),
        child: Row(
          children: [
            Icon(
              _taskCompletionStatus[index]
                  ? Icons.check_box
                  : Icons.check_box_outline_blank,
              color: Colors.green,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  decoration: _taskCompletionStatus[index]
                      ? TextDecoration.lineThrough
                      : null,
                  color: _taskCompletionStatus[index] ? Colors.grey : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}