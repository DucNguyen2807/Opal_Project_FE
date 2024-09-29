import 'dart:convert';
import '../../model/EventCreateRequestModel.dart';
import '../Config/BaseApiService.dart';
import '../Config/config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EventService extends BaseApiService {
  EventService() : super(Config.baseUrl);

  Future<List<Map<String, dynamic>>> getEventsByDate(DateTime date) async {
    final formattedDate = '${date.year}%2F${date.month.toString().padLeft(2, '0')}%2F${date.day.toString().padLeft(2, '0')}';
    final url = Uri.parse('${Config.baseUrl}${Config.getEventsByDateEndpoint}?date=$formattedDate');

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    if (token.isEmpty) {
      throw Exception('Token không hợp lệ');
    }

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final data = List<Map<String, dynamic>>.from(jsonDecode(response.body));
        print('Decoded event data: $data');
        return data;
      } catch (e) {
        print('Failed to decode JSON: $e');
        throw Exception('Failed to decode event data');
      }
    } else {
      throw Exception('Failed to load events: ${response.statusCode} - ${response.body}');
    }
  }

  Future<Map<String, dynamic>> createEvent(EventCreateRequestModel event) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    if (token.isEmpty) {
      throw Exception('Token không hợp lệ');
    }

    final url = Uri.parse('$baseUrl${Config.createEventEndpoint}');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(event.toJson()),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

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
        throw Exception('Failed to create event: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error creating event: $e');
      throw Exception('Error creating event: $e');
    }
  }
}
