import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../Config/BaseApiService.dart';
import '../Config/config.dart';

class AuthService extends BaseApiService {
  AuthService() : super(Config.baseUrl);

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await post('${Config.loginEndpoint}', {
      'username': email,
      'password': password
    });

    if (response.containsKey('token')) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', response['token']);
      await prefs.setString('userInfo', jsonEncode(response['userInfo']));
      String userId = response['userInfo']['userId'];
      await prefs.setString('userId', userId);
      print('Login successful and data saved');
    }

    return response;
  }

  Future<Map<String, dynamic>> register(String username, String fullname, String phoneNumber) async {
    return post('${Config.registerEndpoint}', {
      'username': username,
      'fullname': fullname,
      'phoneNumber' : phoneNumber
    });
  }

  Future<Map<String, dynamic>> sendOTP(String email) async {
    return post('${Config.sendOTPEndpoint}', {
      'email': email,
      'subject': 'Send OTP'
    });
  }

  Future<Map<String, dynamic>> verifyOTP(String email, String otp) async {
    return post('${Config.verifyOTPEndpoint}', {
      'email': email,
      'otp': otp
    });
  }

  Future<Map<String, dynamic>> resetPassword(String email, String newPassword, String confirmPassword) async {
    return post('${Config.resetPasswordEndpoint}', {
      'email': email,
      'newPassword': newPassword,
      'confirmPassword': confirmPassword
    });
  }

  Future<Map<String, dynamic>?> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? userInfoJson = prefs.getString('userInfo');

    if (token != null && userInfoJson != null) {
      Map<String, dynamic> userInfo = jsonDecode(userInfoJson);
      return {
        'token': token,
        'userInfo': userInfo,
      };
    }
    return null;
  }
  Future<Map<String, dynamic>> updateUser(String fullname, String email, String phoneNumber, String gender) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception("User is not logged in");
    }

    final response = await put('${Config.updateUserEndpoint}', {
      'fullname': fullname,
      'email': email,
      'phoneNumber': phoneNumber,
      'gender': gender
    }, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json', // Thêm header Content-Type
    });

    if (response.containsKey('success')) {
      print('User updated successfully');
    }

    return response;
  }

  Future<Map<String, dynamic>> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception("User is not logged in");
    }

    try {
      final response = await get('${Config.loadDataEndpoint}', headers: {
        'Authorization': 'Bearer $token'
      });

      // Ghi log thông tin phản hồi từ API
      print('Load user data response: $response');

      return response;
    } catch (e) {
      // Ghi log lỗi nếu có
      print('Error loading user data: ${e.toString()}');
      throw Exception('Failed to load user data: ${e.toString()}');
    }
  }


  Future<Map<String, dynamic>> changePassword(String oldPassword, String newPassword, String confirmPassword) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception("User is not logged in");
    }

    try {
      final response = await put('${Config.changePasswordEndpoint}', {
        'oldPassword': oldPassword,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword
      }, headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json', // Thêm header Content-Type
      });

      if (response.containsKey('success')) {
        print('Password changed successfully');
      }

      return response;
    } catch (e) {
      print('Error changing password: ${e.toString()}');
      throw Exception('Failed to change password: ${e.toString()}');
    }
  }

}