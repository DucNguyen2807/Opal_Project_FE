import 'package:flutter/material.dart';
import 'package:opal_project/services/UserService/AuthService.dart';
import 'package:opal_project/services/CustomizeService/CustomizeService.dart';
import 'package:opal_project/services/ThemeService/ThemeService.dart';

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
  Map<String, dynamic>? _customizationData;
  Map<String, dynamic>? _themeData;


  // Tạo các TextEditingController
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
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
  bool _isLoading = true;

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
    String loginopal = _themeData?['loginOpal'] ?? 'assets/login-opal.png';

    Color backgroundColor = _customizationData?['uiColor'] != null
        ? Color(int.parse(_customizationData!['uiColor'].substring(2), radix: 16) + 0xFF000000)
        : Colors.white; // Màu mặc định nếu ui_color là null
    Color textBoxColor = _customizationData?['textBoxColor'] != null
        ? Color(int.parse(_customizationData!['textBoxColor'].substring(2), radix: 16) + 0xFF000000)
        : Colors.white;

    Color fontColor = _customizationData?['fontColor'] != null
        ? Color(int.parse(_customizationData!['fontColor'].substring(2), radix: 16) + 0xFF000000)
        : Colors.green;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Thông tin cá nhân',
          style: TextStyle(fontWeight: FontWeight.bold, color: fontColor), // Changed here
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: fontColor),
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
                backgroundImage: AssetImage(loginopal),
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
              buildTextField('Họ và tên của bạn', _fullNameController, textBoxColor),
              const SizedBox(height: 5),
              buildLabel('Email:'),
              buildTextField('Email', _emailController, textBoxColor),
              const SizedBox(height: 5),
              buildLabel('Giới tính:'),
              buildGenderDropdown(textBoxColor),
              const SizedBox(height: 5),
              buildLabel('Số điện thoại:'),
              buildTextField('Số điện thoại', _phoneNumberController, textBoxColor),
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
                  backgroundColor: textBoxColor,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: Text('Xác nhận', style: TextStyle(fontSize: 18, color: Colors.white)),
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

  Widget buildTextField(String hintText, TextEditingController controller, Color textBoxColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: textBoxColor,
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

  Widget buildGenderDropdown(Color textBoxColor) {
    if (_selectedGender != 'Nam' && _selectedGender != 'Nữ' && _selectedGender != 'Khác') {
      _selectedGender = 'Khác';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: textBoxColor,
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
