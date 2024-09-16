import '../Config/BaseApiService.dart';
import '../Config/config.dart';


class AuthService extends BaseApiService {
  AuthService() : super(Config.baseUrl);

  Future<Map<String, dynamic>> login(String email, String password) async {
    return post('${Config.loginEndpoint}', {
      'email': email,
      'password': password,
    });
  }

  Future<Map<String, dynamic>> register(String username, String password) async {
    return post('${Config.registerEndpoint}', {
      'username': username,
      'password': password,
    });
  }
}