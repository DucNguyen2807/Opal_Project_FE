import 'package:flutter/material.dart';

class GoPremiumScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8E5B5),
      appBar: AppBar(
        backgroundColor: Color(0xFFF8E5B5),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.green, size: 30),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Center(
          child: Text(
            "GO PREMIUM",
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 24),
          ),
        ),
        actions: [SizedBox(width: 48)],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              // Image section
              CircleAvatar(
                radius: 100,
                backgroundColor: Colors.white,
                child: Image.asset('assets/OPAL character-10.png', fit: BoxFit.cover),
              ),
              SizedBox(height: 20),
              // Title and description
              Text(
                "Enjoy No-Ads, Including exclusive content only for Premium user",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 30),
              // Subscription options
              buildSubscriptionOption("1 MONTH", "29.000đ", Colors.orange),
              buildSubscriptionOption("6 MONTH", "169.000đ", Colors.orange, bonusText: "Bonus 1 month"),
              buildSubscriptionOption("1 YEAR", "339.000đ", Colors.orange),
              Spacer(),
              GestureDetector(
                onTap: () {
                  // Handle Trial button tap
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(50), // Rounded corners like in the image
                  ),
                  child: Text(
                    "TRIAL 2 WEEK",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Terms and conditions text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  "By placing this order, you agree to the Terms of Service and Privacy Policy. Subscription automatically renews unless auto-renew is turned off at least 24-hours before the end of the current period.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSubscriptionOption(String title, String price, Color color, {String? bonusText}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (bonusText != null)
              Text(
                bonusText,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
            Text(
              price,
              style: TextStyle(
                fontSize: 20,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
