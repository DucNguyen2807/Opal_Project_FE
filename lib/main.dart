import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:opal_project/ui/landing/landing.dart';
import 'package:opal_project/ui/theme-provider/theme.dart';
import 'package:opal_project/ui/Notification/some_widget.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

// Set global HttpOverrides and Firebase initialization
Future<void> main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Gọi hàm getDeviceToken
  await getDeviceToken();

  runApp(const OpalApp());
}

// Hàm lấy Device Token từ Firebase Cloud Messaging
Future<void> getDeviceToken() async {
  String? token = await FirebaseMessaging.instance.getToken();
  print("Device Token: $token");
  // Lưu token này vào server của bạn nếu cần
}

class OpalApp extends StatelessWidget {
  const OpalApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
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
            home: OpalLandingScreen(),
          );
        },
      ),
    );
  }
}
