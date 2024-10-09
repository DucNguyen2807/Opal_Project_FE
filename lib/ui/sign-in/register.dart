import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:opal_project/ui/sign-in/login.dart';
import '../../services/UserService/AuthService.dart';

class OpalRegisterScreen extends StatefulWidget {
  const OpalRegisterScreen({super.key});

  @override
  State<OpalRegisterScreen> createState() => _OpalRegisterScreenState();
}

class _OpalRegisterScreenState extends State<OpalRegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _register() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _authService.register(
        _usernameController.text,
        _fullnameController.text,
        _phoneController.text,
      );

      print('Response Status: ${response['status']}');
      print('Response Message: ${response['message']}');

      if (response['status'] == 'success') {
        print('Navigating to login screen...');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const OpalLoginScreen()),
        );
      } else {
        setState(() {
          _errorMessage = response['message'] ?? 'Đăng ký thất bại!';
        });
      }
    } catch (e, stackTrace) {
      print('Registration error: $e');
      print('Stack trace: $stackTrace');
      setState(() {
        _errorMessage = 'Đã có lỗi xảy ra. Vui lòng thử lại.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Image.asset(
                      'assets/logo.png',
                      height: 100,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    'assets/login-opal.png',
                    height: 150,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 20),

                const Text(
                  'Đăng ký',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5C9933),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                _buildTextField('Tên tài khoản', _usernameController),
                const SizedBox(height: 16),
                _buildTextField('Họ tên', _fullnameController),
                const SizedBox(height: 16),
                _buildTextField('Số điện thoại', _phoneController),
                const SizedBox(height: 16),

                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),

                ElevatedButton(
                  onPressed: _isLoading ? null : _register,
                  child: _isLoading
                      ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                      : const Text('Đăng ký'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFA770),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Bạn đã có tài khoản?'),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const OpalLoginScreen()),
                          );
                        },
                        child: const Text('Đăng nhập'),
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF5C9E31),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Bằng việc tiếp tục bạn đồng ý với',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54),
                ),
                TextButton(
                  onPressed: () {
                    // Chuyển hướng đến điều khoản và chính sách
                  },
                  child: const Text('Term and Privacy Policy'),
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
}
