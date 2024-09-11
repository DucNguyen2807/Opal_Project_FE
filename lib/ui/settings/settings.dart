import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:opal_project/ui/theme-provider/theme.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.isDarkMode ? Colors.black : Color(0xFFF5EAC9),
      appBar: AppBar(
        title: Text('SETTING', style: TextStyle(color: Colors.green)),
        backgroundColor: themeProvider.isDarkMode ? Colors.grey[850] : Color(0xFFF5EAC9),
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
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/login-opal.png'),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Opal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: themeProvider.isDarkMode ? Colors.white : Colors.black)),
                    Text('Personal information', style: TextStyle(color: Colors.grey)),
                  ],
                ),
                Spacer(),
                Icon(Icons.arrow_forward_ios, color: Colors.grey),
              ],
            ),
            SizedBox(height: 20),
            Text('Setting', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: themeProvider.isDarkMode ? Colors.white : Colors.black)),
            SizedBox(height: 20),
            ListTile(
              title: Text('Language', style: TextStyle(color: themeProvider.isDarkMode ? Colors.white : Colors.black)),
              subtitle: Text('English', style: TextStyle(color: Colors.grey)),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
            ),
            ListTile(
              title: Text('Notification', style: TextStyle(color: themeProvider.isDarkMode ? Colors.white : Colors.black)),
              trailing: Switch(
                value: true,
                onChanged: (value) {
                  // Logic cho thông báo
                },
              ),
            ),
            ListTile(
              title: Text('Dark mode', style: TextStyle(color: themeProvider.isDarkMode ? Colors.white : Colors.black)),
              trailing: Switch(
                value: themeProvider.isDarkMode,
                onChanged: (value) {
                  themeProvider.toggleTheme();
                },
              ),
            ),
            ListTile(
              title: Text('Help', style: TextStyle(color: themeProvider.isDarkMode ? Colors.white : Colors.black)),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
            ),
            ListTile(
              title: Text('Sign out', style: TextStyle(color: themeProvider.isDarkMode ? Colors.white : Colors.black)),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
            ),
            ListTile(
              title: Text('Rating', style: TextStyle(color: themeProvider.isDarkMode ? Colors.white : Colors.black)),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}