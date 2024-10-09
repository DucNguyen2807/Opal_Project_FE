import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Config/BaseApiService.dart';
import '../Config/config.dart';

class Feedservice extends BaseApiService {
  Feedservice() : super(Config.baseUrl);

  Future<Map<String, dynamic>> viewParrot() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    if (token.isEmpty) {
      throw Exception('Token không hợp lệ');
    }

    final response = await http.get(
      Uri.parse('${Config.baseUrl}${Config.viewParrotEndpoint}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch parrot data: ${response.statusCode}');
    }
  }

  Future<void> feedParrot(int feedAmount) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    if (token.isEmpty) {
      throw Exception('Token không hợp lệ');
    }

    final response = await http.post(
      Uri.parse('${Config.baseUrl}${Config.feedParrotEndpoint}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'feedAmount': feedAmount,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to feed parrot: ${response.statusCode}');
    }
  }
}

