import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Config/config.dart';

class TaskService {
  final String baseUrl;

  TaskService(this.baseUrl);

  Future<List<Map<String, dynamic>>> getTasksByDate(DateTime date, String token) async {
    final url = Uri.parse('$baseUrl${Config.taskByDateEndPoint}?date=${date.toIso8601String()}');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load tasks: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching tasks: $e');
    }
  }
}
