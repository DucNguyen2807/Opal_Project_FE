import 'dart:convert';
import 'package:http/http.dart' as http;

class BaseApiService {
  final String baseUrl;

  BaseApiService(this.baseUrl);

  Future<Map<String, dynamic>> post(String endpoint, Map<String, String> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      try {
        return jsonDecode(response.body);
      } catch (e) {
        print('Failed to decode JSON: $e');
        return {'status': 'error', 'message': response.body};
      }
    } else {
      throw Exception('Failed to post data');
    }
  }
}