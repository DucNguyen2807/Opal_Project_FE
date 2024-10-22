import 'package:flutter/material.dart';
import 'package:opal_project/services/UserService/AuthService.dart';
import '../reset-password/reset-pass.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:opal_project/services/CustomizeService/CustomizeService.dart';
import 'package:opal_project/services/ThemeService/ThemeService.dart';

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
  Map<String, dynamic>? _customizationData;
  Map<String, dynamic>? _themeData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    endTime = DateTime.now().millisecondsSinceEpoch + 600 * 1000;
    _fetchCustomization();
    _fetchTheme();
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
    String icon5 = _themeData?['icon5'] ?? 'assets/icon opal-05.png';

    Color backgroundColor = _customizationData?['uiColor'] != null
        ? Color(int.parse(_customizationData!['uiColor'].substring(2), radix: 16) + 0xFF000000)
        : Color(0xFFFFE29A);
    Color buttonColor = _customizationData?['buttonColor'] != null
        ? Color(int.parse(_customizationData!['buttonColor'].substring(2), radix: 16) + 0xFF000000)
        : Color(0xFFFFA965);
    Color fontColor = _customizationData?['fontColor'] != null
        ? Color(int.parse(_customizationData!['fontColor'].substring(2), radix: 16) + 0xFF000000)
        : Color(0xFF008000);

    return Scaffold(
      backgroundColor: backgroundColor,
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
                      icon5,
                      fit: BoxFit.cover,
                      width: 80,
                      height: 80,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                 Text(
                  'Kiểm tra Email của bạn',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: fontColor,
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
                    backgroundColor: buttonColor,
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
                    foregroundColor: fontColor,
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
