import 'package:flutter/material.dart';
import 'package:opal_project/services/UserService/AuthService.dart';
import 'package:opal_project/services/Config/CustomException.dart'; // Import CustomException

class UpdatePasswordScreen extends StatefulWidget {
  @override
  _UpdatePasswordScreenState createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFE29A), // Màu nền toàn màn hình
      appBar: AppBar(
        title: Container(
          alignment: Alignment.center, // Căn giữa tiêu đề
          child: Text(
            'Change Password',
            style: TextStyle(
              fontFamily: 'Arista',
              color: Colors.green, // Đổi màu chữ thành xanh
              fontWeight: FontWeight.bold,
              fontSize: 30, // Tăng kích thước chữ
            ),
          ),
        ),
        backgroundColor: Color(0xFFFFA965), // Đặt màu nền trùng với màu bên dưới
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // Đổi màu icon sang trắng
          onPressed: () {
            Navigator.pop(context); // Quay lại màn hình trước
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: ListView(
          children: [
            _buildTextField('Current Password', _currentPasswordController, 'Enter your current password', Icons.lock),
            SizedBox(height: 20),
            _buildTextField('New Password', _newPasswordController, 'Enter your new password', Icons.lock),
            SizedBox(height: 20),
            _buildTextField('Confirm New Password', _confirmPasswordController, 'Confirm your new password', Icons.lock),
            SizedBox(height: 30),
            _buildUpdateButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String hint, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 25, fontFamily: 'Arista', color: Colors.black),
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
              hintStyle: TextStyle(color: Colors.grey, fontFamily: 'KeepCalm'),
              prefixIcon: Icon(icon, color: Color(0xFFFFA965)), // Thêm biểu tượng
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: BorderSide.none,
              ),
            ),
            style: TextStyle(fontFamily: 'Arista', color: Colors.black),
          ),
        ),
      ],
    );
  }

  Widget _buildUpdateButton() {
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
        child: Text('Update Password', style: TextStyle(fontFamily: 'Arista', fontSize: 18)), // Thay đổi kích thước chữ
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFFFA965), // Màu nền nút
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
