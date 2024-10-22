import 'package:flutter/material.dart';
import 'package:opal_project/ui/sign-in/login.dart';
import 'package:opal_project/services/UserService/AuthService.dart';
import 'package:opal_project/services/CustomizeService/CustomizeService.dart';
import 'package:opal_project/services/ThemeService/ThemeService.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  const ResetPasswordScreen({super.key, required this.email});



  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}
class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  Map<String, dynamic>? _themeData;
  Map<String, dynamic>? _customizationData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTheme();
    _fetchCustomization();

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


  @override
  Widget build(BuildContext context) {
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController = TextEditingController();

    String bird = _themeData?['bird'] ?? 'assets/bird.png';

    String font1 = _customizationData?['font1'] ?? 'Arista';
    String font2 = _customizationData?['font2'] ?? 'KeepCalm';
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
                      bird,
                      fit: BoxFit.cover,
                      width: 80,
                      height: 80,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                 Text(
                  'Đặt lại mật khẩu',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: fontColor,
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
                _buildTextField('Mật khẩu mới', passwordController, textBoxColor, obscureText: true),
                const SizedBox(height: 20),
                _buildTextField('Nhập lại mật khẩu', confirmPasswordController, textBoxColor, obscureText: true),
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
                      // Use widget.email to access the email passed to this screen
                      final response = await AuthService().resetPassword(
                        widget.email,
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
                    backgroundColor: textBoxColor,
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

  Widget _buildTextField(String label, TextEditingController controller , Color textBoxColor,  {bool obscureText = false}) {
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
