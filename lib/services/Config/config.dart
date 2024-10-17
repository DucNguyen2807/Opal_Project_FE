class Config {
  static const String baseUrl = 'https://10.0.2.2:7203/api/';

  // User-related endpoints
  static const String loginEndpoint = 'User/login';
  static const String registerEndpoint = 'User/register';
  static const String sendOTPEndpoint = 'OTP/send';
  static const String verifyOTPEndpoint = 'OTP/verify';
  static const String resetPasswordEndpoint = 'User/password/reset';
  static const String updateUserEndpoint = 'User/user/update';
  static const String loadDataEndpoint = 'User/load-data';
  static const String changePasswordEndpoint = 'User/password/change';


  // Task-related endpoints
  static const String taskByDateEndPoint = 'Task/get-task-by-date';
  static const String myTaskByDateEndPoint = 'Task/get-my-task-by-date';
  static const String toggleTaskCompletionEndpoint ='Task/toggle-task-completion';
  static const String createTaskEndpoint ='Task/create-task';
  static const String deleteTaskEndpoint ='Task/delete-task';

  // Event-related endpoint
  static const String getEventsByDateEndpoint = 'Events';
  static const String createEventEndpoint = 'Events/create-event';
  static const String deleteEventEndpoint ='Events/delete-event';

  // Feed-related endpoint
  static const String viewParrotEndpoint = 'Feed/view-parrot';
  static const String feedParrotEndpoint = 'Feed/feed-parrot';

// Customize-related endpoint
  static const String getCustomizeByUser = 'Customize/get-customize-by-user';
  static const String getCustomize = 'Customize/get-customize';
  static const String chooseCustomize = 'Customize/update-customize-by-me';
}
