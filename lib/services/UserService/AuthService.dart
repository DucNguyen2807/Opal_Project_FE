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
      print('Login successful and data saved');
    }

    return response;
  }

  Future<Map<String, dynamic>> register(String username, String password) async {
    return post('${Config.registerEndpoint}', {
      'username': username,
      'password': password
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
}
