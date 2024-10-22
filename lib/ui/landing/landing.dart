import 'package:flutter/material.dart';
import 'package:opal_project/ui/sign-in/login.dart';
import 'package:opal_project/ui/sign-in/register.dart';
import 'package:opal_project/services/CustomizeService/CustomizeService.dart';
import 'package:opal_project/services/ThemeService/ThemeService.dart';

void main() {
  runApp(const OpalApp());
}

class OpalApp extends StatelessWidget {
  const OpalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: OpalLandingScreen(),
    );
  }
}

class OpalLandingScreen extends StatefulWidget {
  const OpalLandingScreen({super.key});

  @override
  State<OpalLandingScreen> createState() => _OpalLandingScreenState();
}

class _OpalLandingScreenState extends State<OpalLandingScreen> {
  Map<String, dynamic>? _customizationData;
  Map<String, dynamic>? _themeData;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double imageHeight = screenHeight < 580 ? screenHeight * 0.6 : screenHeight * 0.8;
    double imageWidth = screenWidth * 1.4;

    double logoHeight = screenWidth > 600 ? 150 : 120;

    String bird = _themeData?['bird'] ?? 'assets/bird.png';
    String logo = _themeData?['logo'] ?? 'assets/logo.png';
    String backGroundImg = _themeData?['icon15'] ?? '';

    Color backgroundColor = _customizationData?['uiColor'] != null
        ? Color(int.parse(_customizationData!['uiColor'].substring(2), radix: 16) + 0xFF000000)
        : Color(0xFFFFE29A); // Màu mặc định là 0xFFFFE29A nếu uiColor là null
    Color fontColor = _customizationData?['fontColor'] != null
        ? Color(int.parse(_customizationData!['fontColor'].substring(2), radix: 16) + 0xFF000000)
        : Color(0xFF008000);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Thêm hình nền
            Positioned.fill(
              child: backGroundImg.isNotEmpty
                  ? Image.asset(
                backGroundImg,
                fit: BoxFit.cover,
              )
                  : Container(color: backgroundColor), // Default background color
            ),
            Positioned(
              top: screenHeight * 0.1,
              right: -screenWidth * 0.4,
              child: Image.asset(
                bird,
                height: imageHeight,
                width: imageWidth,
                fit: BoxFit.contain,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Image.asset(
                        logo,
                        height: logoHeight,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: Column(
                      children: [
                        Text(
                          'Xin chào!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: fontColor,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Bạn đã sẵn sàng để gia nhập chuyến\nphiêu lưu cùng Opal chưa??',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const OpalLoginScreen()),
                            );
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: fontColor,
                            textStyle: const TextStyle(fontSize: 18),
                          ),
                          child: const Text('Đăng nhập!'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const OpalRegisterScreen()),
                            );
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: fontColor,
                            textStyle: const TextStyle(fontSize: 18),
                          ),
                          child: const Text('Đăng kí!'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
