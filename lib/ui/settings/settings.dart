import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:opal_project/ui/theme-provider/theme.dart';
import '../user-profile/user-profile.dart';
import 'package:opal_project/ui/UpdatePasswordSetting/update-password.dart'; // Import trang UpdatePasswordScreen

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Center(
          child: Text(
            'SETTING',
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () {
            Navigator.pop(context);  // Quay lại màn hình trước
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () async {
                // Chuyển sang trang UserProfileScreen và nhận kết quả
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserProfileScreen()),
                );
              },
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.transparent,
                    backgroundImage: AssetImage('assets/login-opal.png'),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Opal',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text('Personal information', style: TextStyle(color: Colors.grey, fontSize: 16)),
                    ],
                  ),
                  Spacer(),
                  Icon(Icons.arrow_forward_ios, color: Colors.grey),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text('Setting', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            _buildSettingItem(context, 'Language', 'English', icon: Icons.language),
            _buildSettingItem(context, 'Change Password', '', icon: Icons.lock, onTap: () {
              // Chuyển sang trang UpdatePasswordScreen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UpdatePasswordScreen()),
              );
            }),
            _buildSettingSwitch(context, 'Notification', true, icon: Icons.notifications),
            _buildSettingSwitch(context, 'Dark mode', themeProvider.isDarkMode, icon: Icons.dark_mode),
            _buildSettingItem(context, 'Help', '', icon: Icons.help),
            _buildSettingItem(context, 'Sign out', '', icon: Icons.exit_to_app, onTap: () {
              _showLogoutDialog(context);
            }),
            _buildSettingItem(context, 'Rating', '', icon: Icons.star),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(BuildContext context, String title, String subtitle, {IconData? icon, VoidCallback? onTap}) {
    return ListTile(
      leading: icon != null ? Icon(icon, color: Colors.grey) : null,
      title: Text(title),
      subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
      trailing: onTap != null ? Icon(Icons.arrow_forward_ios, color: Colors.grey) : null,
      onTap: onTap,
    );
  }

  Widget _buildSettingSwitch(BuildContext context, String title, bool value, {IconData? icon}) {
    return ListTile(
      leading: icon != null ? Icon(icon, color: Colors.grey) : null,
      title: Text(title),
      trailing: Switch(
        value: value,
        onChanged: (newValue) {
          // Xử lý sự kiện khi bật/tắt switch
        },
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Sign out'),
          content: Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Sign out'),
              onPressed: () {
                Navigator.of(context).pop();
                // Xử lý sự kiện khi đăng xuất
              },
            ),
          ],
        );
      },
    );
  }
}
