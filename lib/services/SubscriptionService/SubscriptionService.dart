import 'dart:convert';

import '../Config/BaseApiService.dart';
import '../Config/config.dart';
import 'package:http/http.dart' as http;

class SubscriptionService extends BaseApiService {
  SubscriptionService() : super(Config.baseUrl);

  Future<List<Map<String, dynamic>>> fetchActiveSubscriptions() async {
    final response = await get(Config.activeSubscriptionEndpoint);
    if (response['subscription'] != null) {
      return List<Map<String, dynamic>>.from(response['subscription']);
    } else {
      throw Exception('Failed to load subscriptions');
    }
  }

  Future<Map<String, dynamic>> fetchPaymentUrl(String subscriptionId, String token) async {
    final url = Uri.parse('${Config.baseUrl}${Config.subscriptionPaymentEndpoint}');

    // Define the redirect URL (ensure this is the correct URL your backend expects)
    final redirectUrl = 'https://opal-admin.vercel.app/tien?'; // Replace with your actual redirect URL

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'subscriptionId': subscriptionId,
        'RedirectUrl': redirectUrl,
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body);
        if (data['isSuccess']) {
          return data['data'];
        } else {
          throw Exception('Failed to fetch payment URL');
        }
      } catch (e) {
        print('Failed to decode JSON: $e');
        throw Exception('Failed to decode payment URL data');
      }
    } else {
      throw Exception('Failed to fetch payment URL: ${response.statusCode} - ${response.body}');
    }
  }

}
