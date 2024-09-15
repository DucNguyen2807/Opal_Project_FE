import 'package:flutter/material.dart';
import '../EventPage/EventPage.dart';
import '../settings/settings.dart';

class CustomBottomBar extends StatelessWidget {
  final Function() onFirstButtonPressed;
  final Function() onSecondButtonPressed;
  final Function() onEventButtonPressed;
  final Function() onFourthButtonPressed;
  final Function() onSettingsButtonPressed;

  const CustomBottomBar({
    Key? key,
    required this.onFirstButtonPressed,
    required this.onSecondButtonPressed,
    required this.onEventButtonPressed,
    required this.onFourthButtonPressed,
    required this.onSettingsButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Image.asset(
              'assets/icon opal-01.png',
              width: 54,
              height: 54,
            ),
            onPressed: onFirstButtonPressed,
          ),
          IconButton(
            icon: Image.asset(
              'assets/icon opal-07.png',
              width: 54,
              height: 54,
            ),
            onPressed: onSecondButtonPressed,
          ),
          IconButton(
            icon: Image.asset(
              'assets/icon opal-08.png',
              width: 54,
              height: 54,
            ),
            onPressed: onEventButtonPressed,
          ),
          IconButton(
            icon: Image.asset(
              'assets/icon opal-09.png',
              width: 54,
              height: 54,
            ),
            onPressed: onFourthButtonPressed,
          ),
          IconButton(
            icon: Icon(Icons.settings, color: Colors.green),
            iconSize: 50,
            onPressed: onSettingsButtonPressed,
          ),
        ],
      ),
    );
  }
}