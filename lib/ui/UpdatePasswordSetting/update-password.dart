import 'package:flutter/material.dart';
import 'package:opal_project/services/UserService/AuthService.dart';
import 'package:opal_project/services/Config/CustomException.dart'; // Import CustomException
import 'package:opal_project/services/CustomizeService/CustomizeService.dart';

class UpdatePasswordScreen extends StatefulWidget {
  @override
  _UpdatePasswordScreenState createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  Map<String, dynamic>? _customizationData;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchCustomization();
  }

  final AuthService _authService = AuthService();

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
    String font1 = _customizationData?['font1'] ?? 'Arista';
    String font2 = _customizationData?['font2'] ?? 'KeepCalm';
    Color backgroundColor = _customizationData?['uiColor'] != null
        ? Color(int.parse(_customizationData!['uiColor'].substring(2), radix: 16) + 0xFF000000)
        : Colors.white; // Màu mặc định nếu ui_color là null
    Color textBoxColor = _customizationData?['textBoxColor'] != null
        ? Color(int.parse(_customizationData!['textBoxColor'].substring(2), radix: 16) + 0xFF000000)
        : Colors.white;
    Color buttonColor = _customizationData?['buttonColor'] != null
        ? Color(int.parse(_customizationData!['buttonColor'].substring(2), radix: 16) + 0xFF000000)
        : Colors.green;
    Color fontColor = _customizationData?['fontColor'] != null
        ? Color(int.parse(_customizationData!['fontColor'].substring(2), radix: 16) + 0xFF000000)
        : Colors.green;

    return Scaffold(
      backgroundColor: backgroundColor, // Màu nền toàn màn hình
      appBar: AppBar(
        title: Container(

          child: Text(
            'Change Password',
            style: TextStyle(
              fontFamily: font1,
              color: fontColor, // Đổi màu chữ thành xanh
              fontWeight: FontWeight.bold,
              fontSize: 27, // Tăng kích thước chữ
            ),
          ),
        ),
        backgroundColor: backgroundColor, // Đặt màu nền trùng với màu bên dưới
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: fontColor), // Đổi màu icon sang trắng
          onPressed: () {
            Navigator.pop(context); // Quay lại màn hình trước
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(19.0),
        child: ListView(
          children: [
            _buildTextField('Current Password', _currentPasswordController, 'Enter your current password', Icons.lock, font1, font2),
            SizedBox(height: 20),
            _buildTextField('New Password', _newPasswordController, 'Enter your new password', Icons.lock, font1, font2),
            SizedBox(height: 20),
            _buildTextField('Confirm New Password', _confirmPasswordController, 'Confirm your new password', Icons.lock, font1, font2),
            SizedBox(height: 30),
            _buildUpdateButton(font1, buttonColor),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String hint, IconData icon, String font1, String font2) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 20, fontFamily: font1, color: Colors.black),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white, // Đặt màu nền trắng cho TextField
            borderRadius: BorderRadius.circular(20.0), // Bo góc khung
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 2)), // Thêm bóng cho TextField
            ],
          ),
          child: TextField(
            controller: controller,
            obscureText: true,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey, fontFamily: font2),
              prefixIcon: Icon(icon, color: Color(0xFFFFA965)), // Thêm biểu tượng
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: BorderSide.none,
              ),
            ),
            style: TextStyle(fontFamily: font1, color: Colors.black),
          ),
        ),
      ],
    );
  }

  Widget _buildUpdateButton(String font1, Color buttonColor) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          if (_newPasswordController.text == _confirmPasswordController.text) {
            try {
              await _authService.changePassword(
                _currentPasswordController.text,
                _newPasswordController.text,
                _confirmPasswordController.text,
              );

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Mật khẩu đã được cập nhật thành công')),
              );
              Navigator.pop(context, true); // Quay lại và thông báo thành công
            } catch (e) {
              String errorMessage = (e is CustomException) ? e.message : 'Cập nhật mật khẩu thất bại';
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(errorMessage)),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Mật khẩu mới và xác nhận không khớp')),
            );
          }
        },
        child: Text('Update Password', style: TextStyle(fontFamily: font1, fontSize: 18, color: Colors.black)), // Thay đổi kích thước chữ
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor, // Màu nền nút
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          elevation: 5, // Thêm hiệu ứng bóng cho nút
        ),
      ),
    );
  }
}
