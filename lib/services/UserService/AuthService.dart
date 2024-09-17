import '../Config/BaseApiService.dart';
import '../Config/config.dart';


class AuthService extends BaseApiService {
  AuthService() : super(Config.baseUrl);

  Future<Map<String, dynamic>> login(String email, String password) async {
    return post('${Config.loginEndpoint}', {
      'username': email,
      'password': password,
    });
  }

  Future<Map<String, dynamic>> register(String username, String password) async {
    return post('${Config.registerEndpoint}', {
      'username': username,
      'password': password,
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
    Future<Map<String, dynamic>> resetPassword(String email, String newPassword,
        String confirmPassword) async {
      return post('${Config.resetPasswordEndpoint}', {
        'email': email,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      });
    }
  }

