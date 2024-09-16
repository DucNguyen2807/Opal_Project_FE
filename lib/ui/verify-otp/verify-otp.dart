import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';

import '../reset-password/reset-pass.dart';

class OpalVerificationScreen extends StatefulWidget {
  const OpalVerificationScreen({super.key});

  @override
  _OpalVerificationScreenState createState() => _OpalVerificationScreenState();
}

class _OpalVerificationScreenState extends State<OpalVerificationScreen> {
  late int endTime;

  @override
  void initState() {
    super.initState();
    endTime = DateTime.now().millisecondsSinceEpoch + 600 * 1000;
  }

  void _onConfirm() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ResetPasswordScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EAC9),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/icon opal-05.png',
                      fit: BoxFit.cover,
                      width: 120,
                      height: 120,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Kiểm tra điện thoại của bạn',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5C9933),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Chúng tôi đã gửi mã xác nhận đến điện thoại của bạn',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (index) {
                    return Container(
                      width: 60,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextField(
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 15),
                          counterText: '',
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 20),
                CountdownTimer(
                  endTime: endTime,
                  widgetBuilder: (context, time) {
                    if (time == null) {
                      return const Text(
                        'Mã đã hết hạn',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.red,
                        ),
                      );
                    }
                    return Text(
                      'Mã sẽ hết hạn trong ${time.min} phút ${time.sec} giây',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _onConfirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFA770),
                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 40),
                  ),
                  child: const Text('Xác nhận'),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    // Xử lý gửi lại mã
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF5C9E31),
                  ),
                  child: const Text('Gửi lại mã'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}