import 'package:flutter/material.dart';
import 'package:opal_project/ui/sign-in/login.dart'; // Đảm bảo đường dẫn đúng

void main() {
  runApp(const OpalApp());
}

class OpalApp extends StatelessWidget {
  const OpalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: OpalLandingScreen(),
    );
  }
}

class OpalLandingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5EAC9),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Image.asset(
                    'assets/logo.png',
                    height: 120,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Image.asset(
                    'assets/bird.png',
                    height: 600,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Column(
                  children: [
                    Text(
                      'Xin chào!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF7EBB42),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Bạn đã sẵn sàng để gia nhập chuyến\nphiêu lưu cùng Opal chưa??',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        // Chuyển hướng đến OpalLoginScreen
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => OpalLoginScreen()),
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Color(0xFF5C9E31),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                      child: const Text('Đăng nhập!'),
                    ),
                    TextButton(
                      onPressed: () {
                        // Xử lý chuyển hướng đến màn hình Đăng ký
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Color(0xFF5C9E31),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                      child: const Text('Đăng kí!'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}