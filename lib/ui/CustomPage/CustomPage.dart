import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:opal_project/services/CustomizeService/CustomizeService.dart';

// Định nghĩa CustomException
class CustomException implements Exception {
  final String message;

  CustomException(this.message);

  @override
  String toString() {
    return message;
  }
}

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Customization Gallery',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CustomPage(),
    );
  }
}

class CustomPage extends StatefulWidget {
  @override
  _CustomPageState createState() => _CustomPageState();
}

class _CustomPageState extends State<CustomPage> with TickerProviderStateMixin {
  late CustomizeService _customizeService;
  List<Map<String, dynamic>> _customizations = [];
  bool _isLoading = true;
  Map<String, dynamic>? _customizationData;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _customizeService = CustomizeService();
    _fetchCustomize();
    _fetchCustomization();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _fetchCustomization() async {
    try {
      final data = await _customizeService.getCustomizeByUser();
      setState(() {
        _customizationData = data;
        _isLoading = false;
      });
    } catch (e) {
      print('Lỗi khi lấy dữ liệu tùy chỉnh: $e');
      _showErrorDialog('Lỗi khi lấy dữ liệu tùy chỉnh: ${e.toString()}');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchCustomize() async {
    try {
      final response = await _customizeService.getCustomize();

      if (response is List<dynamic>) {
        setState(() {
          _customizations = List<Map<String, dynamic>>.from(response);
          _isLoading = false;
        });
      } else {
        throw CustomException('Kiểu phản hồi không như mong đợi: ${response.runtimeType}');
      }
    } catch (e) {
      print('Lỗi khi lấy dữ liệu tùy chỉnh: $e');
      _showErrorDialog('Lỗi khi lấy dữ liệu tùy chỉnh: ${e.toString()}');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateCustomization(int customizeId) async {
    try {
      await _customizeService.updateUserCustomize(customizeId);
      _fetchCustomization();
    } catch (e) {
      String errorMessage;
      if (e is CustomException) {
        errorMessage = e.message;
      } else {
        errorMessage = 'Bạn ơi mua gói Premium đê';
      }

      // Hiển thị thông báo lỗi
      _showErrorDialog(errorMessage);
    }
  }



  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.error, color: Colors.red), // Thêm biểu tượng cảnh báo
              SizedBox(width: 8), // Khoảng cách giữa biểu tượng và tiêu đề
              Text('Lỗi'), // Tiêu đề
            ],
          ),
          content: Text(message), // Thông điệp lỗi
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue, // Màu chữ nút
              ),
              child: Text('Đồng ý'), // Nút để đóng hộp thoại
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    String font1 = _customizationData?['font1'] ?? 'Arista';
    Color backgroundColor = _customizationData?['uiColor'] != null
        ? Color(int.parse(_customizationData!['uiColor'].substring(2), radix: 16) + 0xFF000000)
        : Colors.white;
    Color fontColor = _customizationData?['fontColor'] != null
        ? Color(int.parse(_customizationData!['fontColor'].substring(2), radix: 16) + 0xFF000000)
        : Colors.black;

    return Scaffold(
      backgroundColor: backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Customization Gallery',
          style: TextStyle(fontFamily: font1, fontSize: 24, color: fontColor, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: fontColor),
            onPressed: () {},
          ),
        ],
      ),
      body: _isLoading
          ? Center(
        child: LoadingIndicator(animation: _animation),
      )
          : CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final customization = _customizations[index];
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: CustomCard(
                    color: Color(int.parse(customization['uiColor'])),
                    textBoxColor: Color(int.parse(customization['textBoxColor'])),
                    fontColor: Color(int.parse(customization['fontColor'])),
                    font1: customization['font1'],
                    font2: customization['font2'],
                    isSelected: customization['customizationId'] == _customizationData?['customizationId'],
                    onUpdate: () => _updateCustomization(customization['customizationId']),
                  ),
                );
              },
              childCount: _customizations.length,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final Color color;
  final Color textBoxColor;
  final Color fontColor;
  final String font1;
  final String font2;
  final bool isSelected;
  final VoidCallback onUpdate;

  CustomCard({
    required this.color,
    required this.textBoxColor,
    required this.fontColor,
    required this.font1,
    required this.font2,
    required this.isSelected,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Primary Font: $font1',
                style: TextStyle(fontFamily: font1, fontSize: 18, color: fontColor, fontWeight: FontWeight.bold),
              ),
              if (isSelected)
                Icon(Icons.check_circle, color: Colors.green, size: 24),
            ],
          ),
          SizedBox(height: 10),
          Text(
            'Second Font: $font2',
            style: TextStyle(fontFamily: font2, fontSize: 16, color: fontColor),
          ),
          SizedBox(height: 20),
          ...List.generate(3, (index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  CircleAvatar(radius: 12, backgroundColor: fontColor),
                  SizedBox(width: 15),
                  Expanded(
                    child: Container(
                      height: 12,
                      decoration: BoxDecoration(
                        color: textBoxColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: onUpdate,
              child: Text('Apply Theme', style: TextStyle(color: Colors.white, fontFamily: font2)),
              style: ElevatedButton.styleFrom(
                backgroundColor: fontColor,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  final Animation<double> animation;

  LoadingIndicator({required this.animation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return CircularProgressIndicator(
          value: animation.value,
        );
      },
    );
  }
}
