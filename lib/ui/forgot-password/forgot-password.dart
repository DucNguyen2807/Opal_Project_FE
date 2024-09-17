import 'package:flutter/material.dart';
import '../verify-otp/verify-otp.dart';
import 'package:opal_project/services/UserService/AuthService.dart';

class OpalForgotPasswordScreen extends StatelessWidget {
  const OpalForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final AuthService authService = AuthService();

    return Scaffold(
      backgroundColor: const Color(0xFFFFEAC9),
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
                    'assets/icon opal-05.png',
                    height: 500,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Quên mật khẩu',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5C9933),
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
                _buildTextField('Email', emailController),
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
                    backgroundColor: const Color(0xFFFFA770),
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
                    foregroundColor: const Color(0xFF5C9E31),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFCBA0),
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
