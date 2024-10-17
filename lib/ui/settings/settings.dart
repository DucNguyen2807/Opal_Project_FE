import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:opal_project/ui/theme-provider/theme.dart';
import '../Payment/premium_screen.dart';
import '../user-profile/user-profile.dart';
import 'package:opal_project/ui/UpdatePasswordSetting/update-password.dart';  // Import UpdatePasswordScreen
import 'package:opal_project/services/CustomizeService/CustomizeService.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Map<String, dynamic>? _customizationData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCustomization();
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
    String font1 = _customizationData?['font1'] ?? 'Arista';
    String font2 = _customizationData?['font2'] ?? 'KeepCalm';
    Color backgroundColor = _customizationData?['uiColor'] != null
        ? Color(int.parse(_customizationData!['uiColor'].substring(2), radix: 16) + 0xFF000000)
        : Colors.white; // Default color if ui_color is null
    Color textBoxColor = _customizationData?['textBoxColor'] != null
        ? Color(int.parse(_customizationData!['textBoxColor'].substring(2), radix: 16) + 0xFF000000)
        : Colors.white;
    Color buttonColor = _customizationData?['buttonColor'] != null
        ? Color(int.parse(_customizationData!['buttonColor'].substring(2), radix: 16) + 0xFF000000)
        : Colors.green;
    Color fontColor = _customizationData?['fontColor'] != null
        ? Color(int.parse(_customizationData!['fontColor'].substring(2), radix: 16) + 0xFF000000)
        : Colors.green;

    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Container(
          alignment: Alignment.center, // Căn giữa tiêu đề
          margin: EdgeInsets.only(right: 60.0),
          child: Center( // Căn giữa tiêu đề
            child: Text(
              'SETTING',
              style: TextStyle(color: fontColor, fontWeight: FontWeight.bold, fontSize: 30),
            ),
          ),
        ),
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: fontColor),
          onPressed: () {
            Navigator.pop(context);  // Quay lại
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
                      Text('Personal information', style: TextStyle(color: fontColor, fontSize: 16)),
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
            // Go Premium button
            _buildSettingItem(context, 'Go Premium', '', icon: Icons.upgrade, onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GoPremiumScreen()),
              );
            }),
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
          // Handle switch change
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
                // Handle sign out
              },
            ),
          ],
        );
      },
    );
  }
}
