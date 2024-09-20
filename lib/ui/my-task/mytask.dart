import 'package:flutter/material.dart';
import '../CustomBottomBar/CustomBottomBar.dart';
import '../EventPage/EventPage.dart';
import '../FeedBird/FeedBird.dart';
import '../ToDoListPage/ToDoListPage.dart';
import '../settings/settings.dart';

class MytaskScreen extends StatefulWidget {
  const MytaskScreen({super.key});

  @override
  _MytaskScreenState createState() => _MytaskScreenState();
}

class _MytaskScreenState extends State<MytaskScreen> {
  List<bool> _taskCompletionStatus = [false, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Image.asset(
                    'assets/logo.png',
                    width: 150,
                    height: 150,
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Hi, Opal',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
            TextField(
              decoration: InputDecoration(
                hintText: 'Search tasks',
                fillColor: Colors.orange[100],
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange[200],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Task progress',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '40/40 tasks done',
                    style: TextStyle(fontSize: 15),
                  ),
                  const SizedBox(height: 0),
                  Align(
                    alignment: Alignment.center,
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(color: Colors.green, width: 5),
                          ),
                        ),
                        Align(
                          alignment: Alignment(0.9, 0),
                          child: const Text(
                            '100%',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'June 2',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            const Text(
              'My tasks',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 0),
            Column(
              children: [
                _taskItem('Chạy sự kiện', 0),
                _taskItem('Đi mua đồ', 1),
                _taskItem('Học thiết kế', 2),
              ],
            ),
            const SizedBox(height: 20),
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
          MaterialPageRoute(builder: (context) => EventPage(selectedDate: DateTime.now())),
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

  Widget _taskItem(String title, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _taskCompletionStatus[index] = !_taskCompletionStatus[index];
        });
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
                  color:
                      _taskCompletionStatus[index] ? Colors.grey : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
