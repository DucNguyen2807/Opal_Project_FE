import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class SomeWidget extends StatefulWidget {
  @override
  _SomeWidgetState createState() => _SomeWidgetState();
}

class _SomeWidgetState extends State<SomeWidget> {
  @override
  void initState() {
    super.initState();
    getDeviceToken(); // Gọi hàm tại đây
  }

  Future<void> getDeviceToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print("Device Token: $token");
    // Lưu token này vào server của bạn
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Some Widget'),
      ),
      body: Center(child: Text('Hello World!')),
    );
  }
}
