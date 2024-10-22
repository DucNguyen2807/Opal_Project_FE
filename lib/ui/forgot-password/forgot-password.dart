import 'package:flutter/material.dart';
import '../verify-otp/verify-otp.dart';
import 'package:opal_project/services/UserService/AuthService.dart';
import 'package:opal_project/services/CustomizeService/CustomizeService.dart';
import 'package:opal_project/services/ThemeService/ThemeService.dart';

class OpalForgotPasswordScreen extends StatefulWidget {
  const OpalForgotPasswordScreen({super.key});

  @override
  _OpalForgotPasswordScreenState createState() => _OpalForgotPasswordScreenState();
}

class _OpalForgotPasswordScreenState extends State<OpalForgotPasswordScreen> {
  Map<String, dynamic>? _customizationData;
  Map<String, dynamic>? _themeData;
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
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


  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final AuthService authService = AuthService();

    String icon5 = _themeData?['icon5'] ?? 'assets/icon opal-05.png';

    Color backgroundColor = _customizationData?['uiColor'] != null
        ? Color(int.parse(_customizationData!['uiColor'].substring(2), radix: 16) + 0xFF000000)
        : Color(0xFFFFE29A);
    Color textBoxColor = _customizationData?['textBoxColor'] != null
        ? Color(int.parse(_customizationData!['textBoxColor'].substring(2), radix: 16) + 0xFF000000)
        : Color(0xFFFFA965);
    Color buttonColor = _customizationData?['buttonColor'] != null
        ? Color(int.parse(_customizationData!['buttonColor'].substring(2), radix: 16) + 0xFF000000)
        : Colors.green;
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    icon5,
                    height: 350,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 20),
                 Text(
                  'Quên mật khẩu',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: fontColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Bạn hãy nhập Email để\nchúng tôi gửi mã xác nhận!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextField('Email', emailController, textBoxColor),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (emailController.text.isNotEmpty) {
                      try {
                        // Gọi API gửi OTP
                        final response = await authService.sendOTP(emailController.text);
                        if (response['status'] == 'success') {
                          // Điều hướng đến trang xác thực khi thành công
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OpalVerificationScreen(
                                email: emailController.text,
                              ),
                            ),
                          );
                        } else {
                          // Xử lý lỗi (ví dụ: hiển thị thông báo cho người dùng)
                          print('Gửi OTP thất bại: ${response['message']}');
                        }
                      } catch (e) {
                        print('Lỗi khi gửi OTP: $e');
                      }
                    }
                  },
                  child: const Text('Xác nhận'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: textBoxColor,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    // Xử lý thử cách khác
                  },
                  child: const Text('Thử cách khác'),
                  style: TextButton.styleFrom(
                    foregroundColor: fontColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, Color textBoxColor) {
    return Container(
      decoration: BoxDecoration(
        color: textBoxColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }
}

