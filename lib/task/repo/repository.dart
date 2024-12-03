import 'dart:convert';


import 'package:logger/logger.dart';

import 'package:http/http.dart' as http;


class TaskRepository {
  final Logger logger = Logger();
  final String apiUrl =
      'https://app-project-9.onrender.com/api/task/createtask';
  Future<Map<String, dynamic>> CreateTask(String task, String date, String time) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'task': task,
          'date': date,
          'time': time,
          'userId': userId,
          'menuId': menuId
        }),
      );
      logger.i("API Response: ${response.statusCode} - ${response.body}");
      final responseData = json.decode(response.body);
      return responseData;
    } catch (error) {
      logger.e('Error creating task: $error');

      throw Exception('Error creating task: $error');
    }
  }
}
