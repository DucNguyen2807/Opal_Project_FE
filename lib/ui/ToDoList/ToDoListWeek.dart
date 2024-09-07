import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ToDoListWeek extends StatefulWidget {
  const ToDoListWeek({super.key});

  @override
  State<ToDoListWeek> createState() => _ToDoListWeekState();
}

class _ToDoListWeekState extends State<ToDoListWeek> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text("Theme Data",
          style: TextStyle(
            fontSize: 30
          ),)
        ],
      ),
    );
  }
}
