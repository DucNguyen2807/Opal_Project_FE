import 'package:flutter/material.dart';
import 'package:opal_project/services/UserService/AuthService.dart';
import '../reset-password/reset-pass.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';

class OpalVerificationScreen extends StatefulWidget {
  final String email;
  const OpalVerificationScreen({super.key, required this.email});

  @override
  _OpalVerificationScreenState createState() => _OpalVerificationScreenState();
}

class _OpalVerificationScreenState extends State<OpalVerificationScreen> {
  late int endTime;
  final TextEditingController otpController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    endTime = DateTime.now().millisecondsSinceEpoch + 600 * 1000;
  }

  void _onConfirm() async {
    String otp = otpController.text.trim();
    if (otp.isNotEmpty) {
      try {
        var response = await _authService.verifyOTP(widget.email, otp);
        if (response['status'] == 'success') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResetPasswordScreen(email: widget.email),
            ),
          );
        } else {
          // Hiển thị thông báo lỗi
          _showErrorDialog('Xác minh OTP không thành công');
        }
      } catch (error) {
        _showErrorDialog('Đã xảy ra lỗi. Vui lòng thử lại.');
      }
    } else {
      _showErrorDialog('Vui lòng nhập mã OTP');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Lỗi'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
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
                      width: 80,
                      height: 80,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Kiểm tra Email của bạn',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5C9933),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Chúng tôi đã gửi mã xác nhận đến Email của bạn: ${widget.email}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: otpController,
                  decoration: const InputDecoration(
                    labelText: 'Nhập mã OTP',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
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
                    // Xử lý gửi lại mã OTP
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
