import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:opal_project/ui/sign-in/login.dart';
import '../../services/UserService/AuthService.dart';
import 'package:opal_project/services/CustomizeService/CustomizeService.dart';
import 'package:opal_project/services/ThemeService/ThemeService.dart';

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
  Map<String, dynamic>? _customizationData;
  Map<String, dynamic>? _themeData;

  bool _isLoading = false;
  String? _errorMessage;


  @override
  void initState() {
    super.initState();
    _fetchCustomization();
    _fetchTheme();
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


    String logo = _themeData?['logo'] ?? 'assets/logo.png';
    String loginopal = _themeData?['loginOpal'] ?? 'assets/login-opal.png';
    String backGroundImg = _themeData?['icon15'] ?? '';

    Color backgroundColor = _customizationData?['uiColor'] != null
        ? Color(int.parse(_customizationData!['uiColor'].substring(2), radix: 16) + 0xFF000000)
        : Color(0xFFFFE29A);

    Color textBoxColor = _customizationData?['textBoxColor'] != null
        ? Color(int.parse(_customizationData!['textBoxColor'].substring(2), radix: 16) + 0xFF000000)
        : Color(0xFFFFA965);
    Color buttonColor = _customizationData?['buttonColor'] != null
        ? Color(int.parse(_customizationData!['buttonColor'].substring(2), radix: 16) + 0xFF000000)
        : Color(0xFFFFA965);
    Color fontColor = _customizationData?['fontColor'] != null
        ? Color(int.parse(_customizationData!['fontColor'].substring(2), radix: 16) + 0xFF000000)
        : Color(0xFF008000);



    return Scaffold(
      backgroundColor: backgroundColor,
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
            padding: const EdgeInsets.all(11.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo
                Align(
                  alignment: Alignment.topLeft,  // Align to top-left
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Image.asset(
                      logo,
                      height: 70,
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    loginopal,
                    height: 150,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 10),

                 Text(
                  'Đăng ký',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: fontColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                _buildTextField('Email', _usernameController, textBoxColor),
                const SizedBox(height: 10),
                _buildTextField('Họ tên', _fullnameController, textBoxColor),
                const SizedBox(height: 10),
                _buildTextField('Số điện thoại', _phoneController, textBoxColor),
                const SizedBox(height: 10),

                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 11.0),
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
                    backgroundColor: buttonColor,
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
                          foregroundColor: fontColor,
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
                    foregroundColor: fontColor,
                  ),
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

  Widget _buildTextField(String label, TextEditingController controller, Color textBoxColor, {bool obscureText = false}) {
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
