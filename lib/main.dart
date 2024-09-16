import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:opal_project/ui/landing/landing.dart';
import 'package:opal_project/ui/theme-provider/theme.dart';

// Custom HttpOverrides to bypass SSL certificate validation
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

// Set global HttpOverrides
void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const OpalApp());
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
            home: const OpalLandingScreen(),
          );
        },
      ),
    );
  }
}
