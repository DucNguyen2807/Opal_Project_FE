class Config {
  static const String baseUrl = 'https://10.0.2.2:7203/api/';

  // User-related endpoints
  static const String loginEndpoint = 'User/login';
  static const String registerEndpoint = 'User/register';
  static const String sendOTPEndpoint = 'OTP/send';
  static const String verifyOTPEndpoint = 'OTP/verify';
  static const String resetPasswordEndpoint = 'User/password/reset';

  // Task-related endpoints
  static const String taskByDateEndPoint = 'Task/get-task-by-date';
  static const String toggleTaskCompletionEndpoint ='Task/toggle-task-completion';
  static const String createTaskEndpoint ='Task/create-task';
  static const String deleteTaskEndpoint ='Task/delete-task';

  // Event-related endpoint
  static const String getEventsByDateEndpoint = 'Events';
  static const String createEventEndpoint = 'Events/create-event';
  static const String deleteEventEndpoint ='Events/delete-event';
}
