import 'package:flutter/material.dart';
import 'package:opal_project/ui/sign-in/login.dart';
import 'package:opal_project/services/UserService/AuthService.dart';

class ResetPasswordScreen extends StatelessWidget {
  final String email; // Get the email from the previous screen
  const ResetPasswordScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController = TextEditingController();

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
                      'assets/bird.png',
                      fit: BoxFit.cover,
                      width: 80,
                      height: 80,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Đặt lại mật khẩu',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5C9933),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Bạn hãy nhập mật khẩu mới',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextField('Mật khẩu mới', passwordController, obscureText: true),
                const SizedBox(height: 20),
                _buildTextField('Nhập lại mật khẩu', confirmPasswordController, obscureText: true),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (passwordController.text.isEmpty || confirmPasswordController.text.isEmpty) {
                      _showErrorDialog(context, 'Vui lòng nhập đầy đủ thông tin');
                      return;
                    }

                    if (passwordController.text != confirmPasswordController.text) {
                      _showErrorDialog(context, 'Mật khẩu không trùng khớp!');
                      return;
                    }

                    try {
                      final response = await AuthService().resetPassword(
                        email,
                        passwordController.text,
                        confirmPasswordController.text,
                      );

                      if (response['status'] == 'success') {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const OpalLoginScreen()),
                        );
                      } else {
                        _showErrorDialog(context, 'Đặt lại mật khẩu không thành công!');
                      }
                    } catch (e) {
                      _showErrorDialog(context, 'Đã xảy ra lỗi: $e');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFA770),
                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 40),
                  ),
                  child: const Text('Xác nhận'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool obscureText = false}) {
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
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
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
}
