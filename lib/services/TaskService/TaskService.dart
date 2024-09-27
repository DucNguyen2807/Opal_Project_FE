import 'dart:convert';
import '../Config/BaseApiService.dart';
import '../Config/config.dart';
import 'package:http/http.dart' as http;
import 'package:opal_project/model/TaskCreateRequestModel.dart';
class TaskService extends BaseApiService {
  TaskService() : super(Config.baseUrl);

  // Phương thức lấy task theo ngày
  Future<List<Map<String, dynamic>>> getTasksByDate(DateTime date, String token) async {
    final url = Uri.parse('$baseUrl${Config.taskByDateEndPoint}?date=${date.toIso8601String()}');
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
        print('Decoded data: $data');
        return data;
      } catch (e) {
        print('Failed to decode JSON: $e');
        throw Exception('Failed to decode tasks data');
      }
    } else {
      throw Exception('Failed to load tasks: ${response.statusCode} - ${response.body}');
    }
  }

  // Phương thức chuyển đổi trạng thái hoàn thành của task
  Future<bool> toggleTaskCompletion(String taskId, String token) async {
    if (taskId.isEmpty) {
      throw Exception('Task ID cannot be empty.');
    }

    final url = Uri.parse('$baseUrl${Config.toggleTaskCompletionEndpoint}/$taskId');

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 404) {
      throw Exception('Task not found or no permission');
    } else {
      throw Exception('Failed to update task completion status');
    }
  }

  // Thêm phương thức tạo task mới
  Future<bool> createTask(TaskCreateRequestModel task, String token) async {
    final url = Uri.parse('$baseUrl${Config.createTaskEndpoint}');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(task.toJson()),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return true; // Task tạo thành công
      } else {
        print('Failed to create task: ${response.body}');
        return false; // Task tạo thất bại
      }
    } catch (e) {
      print('Error creating task: $e');
      return false;
    }
  }
  // Phương thức xóa task
  Future<bool> deleteTask(String taskId, String token) async {
    if (taskId.isEmpty) {
      throw Exception('Task ID cannot be empty.');
    }

    final url = Uri.parse('$baseUrl${Config.deleteTaskEndpoint}/$taskId');

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return true; // Xóa task thành công
      } else if (response.statusCode == 404) {
        throw Exception('Task not found or no permission');
      } else {
        throw Exception('Failed to delete task');
      }
    } catch (e) {
      print('Error deleting task: $e');
      return false; // Xóa task thất bại
    }
  }

}
