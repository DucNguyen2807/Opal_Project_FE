import 'package:shared_preferences/shared_preferences.dart';
import '../Config/BaseApiService.dart';
import '../Config/config.dart';
import 'dart:convert'; // Đảm bảo rằng bạn đã import dart:convert
import 'package:http/http.dart' as http;

class Themeservice extends BaseApiService {
  Themeservice() : super(Config.baseUrl);

  Future<Map<String, dynamic>> getCustomizeByUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    print('User ID: $userId');

    if (userId == null) {
      throw Exception('UserId not found');
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl${Config.getThemeByUser}/$userId'),
      );

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        // Parse JSON từ response.body
        Map<String, dynamic> data = json.decode(response.body);

        // Log dữ liệu đã phân tích
        print('Parsed Data: ${json.encode(data)}'); // Log JSON ra console

        return data;
      } else {
        throw Exception('Failed to get data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching customization: $e');
      throw Exception('Failed to fetch customization');
    }
  }

  Future<List<Map<String, dynamic>>> getCustomize() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl${Config.getTheme}'), headers: {});
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}'); // In ra phản hồi trực tiếp

      if (response.statusCode == 200) {
        try {
          final List<dynamic> jsonResponse = jsonDecode(response.body);
          final List<Map<String, dynamic>> customizations = List<Map<String, dynamic>>.from(jsonResponse);
          print('Decoded customizations: $customizations');
          return customizations;
        } catch (e) {
          print('Failed to decode JSON: $e');
          throw Exception('Failed to decode customization data');
        }
      } else {
        throw Exception('Failed to load customizations: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching customization: $e');
      throw Exception('Failed to fetch customization');
    }
  }

  Future<void> updateUserCustomize(int customizeId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token not found');
    }

    try {
      final response = await http.put(
        Uri.parse('$baseUrl${Config.chooseTheme}/$customizeId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print('Customization updated successfully');
      } else {
        // Lấy thông tin lỗi từ phản hồi
        String errorMessage = response.body; // Hoặc sử dụng json.decode nếu có định dạng JSON
        throw Exception('Failed to update customization: ${response.statusCode} - $errorMessage');
      }
    } catch (e) {
      print('Error updating customization: $e');
      throw Exception('Failed to update customization');
    }
  }


}
