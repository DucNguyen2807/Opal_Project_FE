import 'dart:io';
import 'package:flutter/material.dart';
import 'package:opal_project/ui/Notification/notification.dart';
import 'package:provider/provider.dart';
import 'package:opal_project/ui/landing/landing.dart';
import 'package:opal_project/ui/theme-provider/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  if (const bool.fromEnvironment('dart.vm.product') == false) {
    HttpOverrides.global = MyHttpOverrides();
  }
  runApp(const OpalApp());
}

class OpalApp extends StatelessWidget {
  const OpalApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading token'));
        } else {
          String token = snapshot.data ?? '';
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => ThemeProvider()),
              Provider<NotificationService>(
                create: (context) => NotificationService(token),
              ),
            ],
            child: Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                final notificationService = Provider.of<NotificationService>(context, listen: false);
                notificationService.onReceiveNotification((message) => _handleNotification(context, message));
                notificationService.start();
                return MaterialApp(
                  title: 'Opal Project',
                  theme: ThemeData(
                    brightness: themeProvider.isDarkMode ? Brightness.dark : Brightness.light,
                    primarySwatch: Colors.green,
                    scaffoldBackgroundColor: const Color(0xFFFFF1AD),
                    appBarTheme: AppBarTheme(
                      backgroundColor: themeProvider.isDarkMode ? Colors.grey[850] : const Color(0xFFF5EAC9),
                      elevation: 0,
                    ),
                  ),
                  home: const OpalLandingScreen(),
                );
              },
            ),
          );
        }
      },
    );
  }

  Future<String> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  void _handleNotification(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Thông báo"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
