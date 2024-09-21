import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:opal_project/ui/theme-provider/theme.dart';
import 'package:opal_project/ui/sign-in/login.dart';

import '../user-profile/user-profile.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('SETTING', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
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
          // Logic to handle the switch state change can go here
        },
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Color(0xFFF5EAC9),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "You really want to sign out?",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.transparent,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/icon opal-05.png',
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange[200],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => OpalLoginScreen()),
                        );
                      },
                      child: Text("Yes"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[400],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("No"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}