import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/SubscriptionService/SubscriptionService.dart';
import 'PaymentWebView.dart';

class GoPremiumScreen extends StatelessWidget {
  final SubscriptionService subscriptionService = SubscriptionService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF4D9),
      appBar: AppBar(
        backgroundColor: Color(0xFFFFF4D9),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF4CAF50), size: 30),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "GO PREMIUM",
          style: TextStyle(
            color: Color(0xFF4CAF50),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        actions: [SizedBox(width: 48)],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: subscriptionService.fetchActiveSubscriptions(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No subscriptions available.'));
              }

              // If we have data, display it
              final subscriptions = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  CircleAvatar(
                    radius: 85,
                    backgroundColor: Colors.white,
                    child: Image.asset('assets/Opal-15.png', fit: BoxFit.cover),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Enjoy No-Ads, Including exclusive content only for Premium users",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 10),
                  // Display subscription options dynamically
                  ...subscriptions.map((sub) {
                    print('Subscription ID: ${sub['subscriptionId']}'); // Log the subscription ID
                    return buildSubscriptionOption(
                      sub['subName'],
                      '${sub['price']}đ',
                      sub['subDescription'],
                      Color(0xFFFFA57A),
                          () => _handleSubscriptionTap(context, sub['subscriptionId']),
                    );
                  }).toList(),
                  Spacer(),
                  // Trial button
                  GestureDetector(
                    onTap: () {
                      // Handle Trial button tap
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Color(0xFF4CAF50),
                        borderRadius: BorderRadius.circular(50),
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
                  SizedBox(height: 50),
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
                  SizedBox(height: 30),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildSubscriptionOption(String title, String price, String description,
      Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 10),
          margin: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.8),
            borderRadius: BorderRadius.circular(40),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Text(
                      price,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0, left: 10, right: 20),
                child: Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSubscriptionTap(BuildContext context, String? subscriptionId) async {
    if (subscriptionId == null || subscriptionId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid subscription ID.')),
      );
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token != null && token.isNotEmpty) {
        final paymentData = await subscriptionService.fetchPaymentUrl(subscriptionId, token);
        final paymentUrl = paymentData['paymentUrl'];

        // Navigate to the PaymentWebView screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentWebView(paymentUrl: paymentUrl),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Token is missing. Please log in again.')),
        );
      }
    } catch (e) {
      print('Error fetching payment URL: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to initiate payment: $e')),
      );
    }
  }

}
