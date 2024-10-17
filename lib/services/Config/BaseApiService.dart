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

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.body.isEmpty) {
        return {'status': 'success'};
      }
      try {
        return jsonDecode(response.body);
      } catch (e) {
        print('Failed to decode JSON: $e');
        return {'status': 'error', 'message': response.body};
      }
    } else {
      print('Error: ${response.body}'); // In ra thông tin lỗi
      throw Exception('Failed to post data: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> get(String endpoint, {Map<String, String>? headers}) async {
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers ?? <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
    );

    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        return jsonDecode(response.body);
      } catch (e) {
        print('Failed to decode JSON: $e');
        return {'status': 'error', 'message': response.body};
      }
    } else {
      print('Error: ${response.body}'); // In ra thông tin lỗi
      throw Exception('Failed to get data: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> put(String endpoint, Map<String, String> data, {Map<String, String>? headers}) async {
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers ?? <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(data),
    );

    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        return jsonDecode(response.body);
      } catch (e) {
        print('Failed to decode JSON: $e');
        return {'status': 'error', 'message': response.body};
      }
    } else {
      print('Error: ${response.body}'); // In ra thông tin lỗi
      throw Exception('Failed to put data: ${response.body}');
    }
  }
}
