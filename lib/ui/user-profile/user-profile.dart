import 'package:flutter/material.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF2BC),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            const Text(
              'Thông tin cá nhân',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF73A942),
              ),
            ),
            const SizedBox(height: 50),
            CircleAvatar(
              radius: 100,
              backgroundColor: Colors.transparent,
              backgroundImage: const AssetImage('assets/login-opal.png'),
            ),
            const SizedBox(height: 10),
            const Text(
              'Opal',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const Text(
              'Thông tin cá nhân',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 30),

            buildLabel('Họ và tên :'),
            buildTextField('Họ và tên của bạn'),
            const SizedBox(height: 15),

            buildLabel('Email:'),
            buildTextField('Email'),
            const SizedBox(height: 15),

            buildLabel('Sinh nhật:'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(child: buildDropdown('Ngày')),
                const SizedBox(width: 15),
                Expanded(child: buildDropdown('Tháng')),
                const SizedBox(width: 15),
                Expanded(child: buildDropdown('Năm')),
              ],
            ),
            const SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(child: buildDropdown('Giới tính')),
                const SizedBox(width: 15),
                Expanded(child: buildDropdown('Quốc tịch')),
              ],
            ),
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF73A942),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Xác nhận',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String hintText) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
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

  Widget buildDropdown(String hintText) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFAA7B),
        borderRadius: BorderRadius.circular(30),
      ),
      child: DropdownButton<String>(
        underline: const SizedBox(),
        isExpanded: true,
        hint: Text(
          hintText,
          style: const TextStyle(color: Colors.black54),
        ),
        items: ['Option 1', 'Option 2', 'Option 3']
            .map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (newValue) {},
      ),
    );
  }
}