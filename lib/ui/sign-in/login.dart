import 'package:flutter/material.dart';
import 'package:opal_project/ui/forgot-password/forgot-password.dart';
import 'package:opal_project/ui/HomePage/HomePage.dart';
import 'package:opal_project/services/UserService/AuthService.dart';
import 'package:opal_project/ui/sign-in/register.dart';
import 'package:opal_project/services/CustomizeService/CustomizeService.dart';
import 'package:opal_project/services/ThemeService/ThemeService.dart';
import 'dart:convert';

class OpalLoginScreen extends StatefulWidget {
  const OpalLoginScreen({super.key});

  @override
  _OpalLoginScreenState createState() => _OpalLoginScreenState();
}

class _OpalLoginScreenState extends State<OpalLoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();
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
      print('Error fetching theme: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _login() async {
    try {
      final response = await _authService.login(
        emailController.text,
        passwordController.text,
      );
      if (!mounted) return;
      if (response.containsKey('token')) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid login')),
        );
      }
    } catch (error) {
      if (mounted) {
        String errorMessage = _parseErrorMessage(error);
        _showErrorDialog(context, errorMessage);
      }
    }
  }

  String _parseErrorMessage(dynamic error) {
    if (error is String) {
      final Map<String, dynamic> jsonError = json.decode(error);
      if (jsonError['errors'] != null) {
        List<String> messages = [];
        jsonError['errors'].forEach((key, value) {
          messages.addAll(value.map<String>((msg) => "$key: $msg"));
        });
        return messages.join('\n');
      }
    }
    return 'An unknown error occurred.';
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

  @override
  Widget build(BuildContext context) {
    String logo = _themeData?['logo'] ?? 'assets/logo.png';
    String loginopal = _themeData?['loginOpal'] ?? 'assets/login-opal.png';
    String backGroundImg = _themeData?['icon15'] ?? '';

    Color backgroundColor = _customizationData?['uiColor'] != null
        ? Color(int.parse(_customizationData!['uiColor'].substring(2), radix: 16) + 0xFF000000)
        : const Color(0xFFFFE29A);
    Color textBoxColor = _customizationData?['textBoxColor'] != null
        ? Color(int.parse(_customizationData!['textBoxColor'].substring(2), radix: 16) + 0xFF000000)
        : const Color(0xFFFFA965);
    Color fontColor = _customizationData?['fontColor'] != null
        ? Color(int.parse(_customizationData!['fontColor'].substring(2), radix: 16) + 0xFF000000)
        : const Color(0xFF008000);

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: backGroundImg.isNotEmpty
                ? Image.asset(
              backGroundImg,
              fit: BoxFit.cover,
            )
                : Container(color: backgroundColor), // Default background color
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Image.asset(
                          logo,
                          height: 80,
                        ),
                      ),
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 1.0),
                          child: Image.asset(
                            loginopal,
                            height: 180,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Positioned(
                          top: 50,
                          left: 250,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Text(
                              '  Hi!  ',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: fontColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'Đăng nhập',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: fontColor,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Bạn chưa có tài khoản?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const OpalRegisterScreen(),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: fontColor,
                        ),
                        child: const Text('Đăng kí'),
                      ),
                    ),
                    _buildTextField(
                      emailController,
                      'Tên tài khoản',
                      textBoxColor,
                    ),
                    _buildTextField(
                      passwordController,
                      'Mật khẩu',
                      textBoxColor,
                      obscureText: true,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const OpalForgotPasswordScreen(),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: fontColor,
                        ),
                        child: const Text('Bạn quên mật khẩu?'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: textBoxColor,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                      ),
                      child: const Text('Đăng nhập'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String labelText,
      Color fillColor, {
        bool obscureText = false,
      }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: fillColor,
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
          labelText: labelText,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }
}
