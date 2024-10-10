import 'package:flutter/material.dart';
import 'package:opal_project/services/UserService/AuthService.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String? _selectedGender;
  String _fullName = '';
  String _email = '';
  String _phoneNumber = '';
  final AuthService _authService = AuthService();

  // Tạo các TextEditingController
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    try {
      var userData = await _authService.loadUserData();
      if (userData != null) {
        setState(() {
          _fullName = userData['fullName'] ?? '';
          _email = userData['email'] ?? '';
          _phoneNumber = userData['phoneNumber'] ?? '';
          _selectedGender = userData['gender'] ?? 'Khác';

          // Cập nhật giá trị cho các TextEditingController
          _fullNameController.text = _fullName;
          _emailController.text = _email;
          _phoneNumberController.text = _phoneNumber;
        });
      } else {
        throw Exception('Không thể tải thông tin người dùng');
      }
    } catch (e) {
      print('Failed to load user data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi tải thông tin người dùng: $e')),
      );
    }
  }

  @override
  void dispose() {
    // Giải phóng các TextEditingController khi không còn sử dụng
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF2BC),
      appBar: AppBar(
        title: const Text(
          'Thông tin cá nhân',
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),
      body: SingleChildScrollView( // Allow scrolling
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 0),
              CircleAvatar(
                radius: 100,
                backgroundColor: Colors.transparent,
                backgroundImage: const AssetImage('assets/login-opal.png'),
              ),
              const SizedBox(height: 5),
              const Text(
                'Opal',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const Text(
                'Thông tin cá nhân',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 5),
              buildLabel('Họ và tên :'),
              buildTextField('Họ và tên của bạn', _fullNameController),
              const SizedBox(height: 5),
              buildLabel('Email:'),
              buildTextField('Email', _emailController),
              const SizedBox(height: 5),
              buildLabel('Giới tính:'),
              buildGenderDropdown(),
              const SizedBox(height: 5),
              buildLabel('Số điện thoại:'),
              buildTextField('Số điện thoại', _phoneNumberController),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await _authService.updateUser(
                      _fullNameController.text,
                      _emailController.text,
                      _phoneNumberController.text,
                      _selectedGender ?? 'Khác',
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Cập nhật thành công!')),
                    );
                    Navigator.pop(context, true);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Cập nhật không thành công: $e')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF73A942),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text('Xác nhận', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
    );
  }

  Widget buildTextField(String hintText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFFFAA7B),
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }

  Widget buildGenderDropdown() {
    if (_selectedGender != 'Nam' && _selectedGender != 'Nữ' && _selectedGender != 'Khác') {
      _selectedGender = 'Khác';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFFFAA7B),
          borderRadius: BorderRadius.circular(30),
        ),
        child: DropdownButton<String>(
          value: _selectedGender,
          isExpanded: true,
          underline: const SizedBox(),
          hint: const Text('Chọn giới tính', style: TextStyle(color: Colors.black54)),
          items: ['Nam', 'Nữ', 'Khác'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              _selectedGender = newValue;
            });
          },
        ),
      ),
    );
  }
}
