import 'package:flutter/material.dart';

class FeedBird extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
                          Navigator.pop(context); // Back button functionality
                        },
                      ),
                      Row(
                        children: [
                          Image.asset(
                            'assets/Artboard 20.png',
                            width: 100,
                            height: 100,
                          ),
                          const SizedBox(width: 16), // Adjusted spacing
                          Image.asset(
                            'assets/Artboard 21.png',
                            width: 100,
                            height: 100,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Center(
                  child: Image.asset(
                    'assets/bird1.png',
                    width: 470,
                    height: 470,
                  ),
                ),
                Spacer(),
                // Feed button
                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black, backgroundColor: Colors.white,
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
