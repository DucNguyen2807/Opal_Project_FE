import 'package:flutter/material.dart';
import 'package:opal_project/ui/sign-in/login.dart';
import 'package:opal_project/ui/sign-in/register.dart';

void main() {
  runApp(const OpalApp());
}

class OpalApp extends StatelessWidget {
  const OpalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: OpalLandingScreen(),
    );
  }
}

class OpalLandingScreen extends StatefulWidget {
  const OpalLandingScreen({super.key});

  @override
  State<OpalLandingScreen> createState() => _OpalLandingScreenState();
}

class _OpalLandingScreenState extends State<OpalLandingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 100,
              left: -90,
              child: Image.asset(
                'assets/bird.png',
                height: 700,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
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
                  const Spacer(),
                  const Padding(
                    padding: EdgeInsets.only(top: 5.0),
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
                        SizedBox(height: 8),
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
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const OpalLoginScreen()),
                            );
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF5C9E31),
                            textStyle: const TextStyle(fontSize: 18),
                          ),
                          child: const Text('Đăng nhập!'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const OpalRegisterScreen()),
                            );
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF5C9E31),
                            textStyle: const TextStyle(fontSize: 18),
                          ),
                          child: const Text('Đăng kí!'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
