import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:opal_project/ui/landing/landing.dart'; // Giữ nguyên import của bạn
import 'package:opal_project/ui/theme-provider/theme.dart'; // Thêm đường dẫn đến ThemeProvider

void main() => runApp(const OpalApp());

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
            ),
            home: const OpalLandingScreen(),
          );
        },
      ),
    );
  }
}