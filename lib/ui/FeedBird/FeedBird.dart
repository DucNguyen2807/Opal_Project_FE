import 'package:flutter/material.dart';
import '../../services/FeedService/FeedService.dart';

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

  final Map<int, String> levelImages = {
    1: 'assets/OPAL character-08.png',
    2: 'assets/OPAL character-10.png',
    3: 'assets/OPAL character-07.png',
    4: 'assets/OPAL character-06.png',
  };

  late AnimationController _controller;
  late Animation<Offset> _animation;
  final Feedservice _feedService = Feedservice();

  @override
  void initState() {
    super.initState();
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

  Future<void> fetchParrotData() async {
    try {
      final data = await _feedService.viewParrot();
      setState(() {
        currentLevel = data['parrotLevel'];
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/background.png',
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
                                  Icons.bug_report,
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
                        try {
                          setState(() {
                            isFeeding = true;
                            _controller.forward(from: 0);
                          });

                          await _feedService.feedParrot(1);

                          await fetchParrotData();
                        } catch (e) {
                          print('Error feeding parrot: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Lỗi khi cho vẹt ăn: $e')),
                          );
                        } finally {
                          setState(() {
                          });
                        }
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
