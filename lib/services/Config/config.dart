class Config {
  static const String baseUrl = 'https://10.0.2.2:7203/api/';
  // Add endpoints here
  static const String loginEndpoint = 'User/login';
  static const String registerEndpoint = 'User/register';
  static const String sendOTPEndpoint = 'OTP/send';
  static const String verifyOTPEndpoint = 'OTP/verify';
  static const String resetPasswordEndpoint = 'User/password/reset';
  static const String taskByDateEndPoint = 'Task/get-task-by-date';

}