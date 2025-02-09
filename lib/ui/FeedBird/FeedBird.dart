import 'package:flutter/material.dart';
import '../../services/FeedService/FeedService.dart';
import 'package:opal_project/services/ThemeService/ThemeService.dart';

class FeedBird extends StatefulWidget {
  @override
  _FeedBirdState createState() => _FeedBirdState();
}

class _FeedBirdState extends State<FeedBird> with SingleTickerProviderStateMixin {
  int currentLevel = 1;
  int seedCount = 0;
  double percentGrowth = 0.0;
  bool isLoading = true;
  bool isFeeding = false;
  Map<String, dynamic>? _themeData;
  bool isTransitioning = false;

  final Map<int, String> levelImages = {
    1: 'assets/Trung-lac.gif',
    2: 'assets/Trung-Opal-lac.gif',
    3: 'assets/Opal-be-vay-canh.gif',
    4: 'assets/Opal_lon_1.gif',
  };

  late AnimationController _controller;
  late Animation<Offset> _animation;
  final Feedservice _feedService = Feedservice();
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _fetchTheme();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _animation = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(0, -0.5),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          isFeeding = false;
          _controller.reset();
        });
      }
    });

    Future.microtask(() => fetchParrotData());
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
  Future<void> fetchParrotData() async {
    try {
      final data = await _feedService.viewParrot();

      // Check if we are transitioning from level 1 to level 2
      if (data['parrotLevel'] == 2 && currentLevel == 1) {
        setState(() {
          isTransitioning = true; // Start transition animation
        });

        await Future.delayed(Duration(seconds: 4)); // Show the transition gif for 2 seconds

        setState(() {
          currentLevel = data['parrotLevel'];
          isTransitioning = false; // End transition animation
        });
      } else {
        setState(() {
          currentLevel = data['parrotLevel'];
        });
      }

      setState(() {
        seedCount = data['seedCount'];
        percentGrowth = (data['percentGrowth'] is int)
            ? (data['percentGrowth'] as int).toDouble()
            : data['percentGrowth'];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching parrot data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi tải dữ liệu: $e')),
      );
    }
  }

  Future<void> showFeedDialog() async {
    TextEditingController seedController = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Feed Parrot'),
          content: TextField(
            controller: seedController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: 'Nhập số sâu cho ăn'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('HỦY'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () async {
                final int? seedInput = int.tryParse(seedController.text);

                if (seedInput == null || seedInput <= 0) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(this.context).showSnackBar(
                    SnackBar(content: Text('Vui lòng nhập số sâu hợp lệ')),
                  );
                  return;
                }

                if (seedInput > seedCount) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(this.context).showSnackBar(
                    SnackBar(content: Text('Bạn không đủ sâu để cho ăn')),
                  );
                  return;
                }

                Navigator.of(context).pop();
                setState(() {
                  isFeeding = true;
                  _controller.forward(from: 0);
                });

                try {
                  await _feedService.feedParrot(seedInput);
                  await fetchParrotData();
                } catch (e) {
                  print('Error feeding parrot: $e');
                  ScaffoldMessenger.of(this.context).showSnackBar(
                    SnackBar(content: Text('Lỗi khi cho vẹt ăn: $e')),
                  );
                } finally {
                  setState(() {
                    isFeeding = false;
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    String backgroundBird = _themeData?['backgroundBird'] ?? 'assets/background.png';

    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              backgroundBird,
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.adb_outlined,
                                  size: 30,
                                  color: Colors.orangeAccent,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '$seedCount',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.emoji_emotions,
                                  size: 30,
                                  color: Colors.yellow,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${(percentGrowth).toInt()}%',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Show transition GIF when transitioning from level 1 to 2
                      if (isTransitioning)
                        Image.asset(
                          'assets/Trung-Opal-no.gif', // Your transition GIF
                          width: 470,
                          height: 470,
                        )
                      else
                        Image.asset(
                          levelImages[currentLevel]!,
                          width: 470,
                          height: 470,
                        ),
                      if (isFeeding)
                        SlideTransition(
                          position: _animation,
                          child: Image.asset(
                            'assets/OPAL character-09.png',
                            width: 100,
                            height: 100,
                          ),
                        ),
                    ],
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        await showFeedDialog();
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 40.0,
                        ),
                      ),
                      child: Text(
                        'FEED',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
