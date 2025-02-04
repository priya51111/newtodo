
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:newtodo/task/model.dart';

import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:timezone/timezone.dart' as tz;
class TaskRepository {
  Logger logger = Logger();
  final String createUrl =
      'https://app-project-9.onrender.com/api/task/createtask';
  final GetStorage storage = GetStorage();

  Future<Map<String, dynamic>> createTask(
      String task, String date, String time) async {
    try {
      final userId = storage.read('userId');
      final menuId = storage.read('menuId');
      final token = storage.read('token');

      logger.i('User ID: $userId, Menu ID: $menuId, Token: $token');
      logger.i('Task: $task, Date: $date, Time: $time');

      final response = await http.post(
        Uri.parse(createUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'task': task,
          'date': date,
          'time': time,
          'userId': userId,
          'menuId': menuId,
        }),
      );

      logger.i("TaskRepository ::: createTask:: $response");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final taskData = responseData['data']['task'];
        if (taskData != null) {
            await _scheduleNotification(
              FlutterLocalNotificationsPlugin(),
           task,
            date,
            time
      );
          final taskId = taskData['_id'];
          final taskDate = taskData['date'];

          storage.write('taskId', taskId);
          storage.write('taskDate', taskDate);

          logger.i('Task created with ID: $taskId, date of task: $taskDate');
          return taskData;
        } else {
          throw Exception('Task data is missing in the response');
        }
      } else {
        throw Exception(
            'Failed to create task: ${response.statusCode} - ${response.body}');
      }
    } catch (error) {
      logger.e('Error creating task: $error');
      rethrow;
    }
  }

  Future<List<Task>> fetchTasks(
      {required String userId, required String date}) async {
    try {
      final token = storage.read('token');
      final storedDate = storage.read('taskDate');

      if (storedDate == null) {
        throw Exception("Task date not found in GetStorage");
      }

      logger.i("Using saved date for fetchTask: $storedDate");

      final response = await http.get(
        Uri.parse(
            'https://app-project-9.onrender.com/api/task/gettask/$userId/$storedDate'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      logger.i('TaskRepossitory ::: fetchTask:: $response');
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData['data'] != null && jsonData['data']['task'] != null) {
          final tasks = (jsonData['data']['task'] as List)
              .map((task) => Task.fromJson(task))
              .toList();
          logger.i('Parsed ${tasks.length} tasks from the response.');

          return tasks;
        } else {
          logger.e('Invalid response: Task data is missing.');
          throw Exception('Invalid response: Task data is missing');
        }
      } else {
        logger.e(
            'Failed to load tasks: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load tasks: ${response.statusCode}');
      }
    } catch (error) {
      logger.e('Error fetching tasks: $error');
      throw Exception('Error fetching tasks: $error');
    }
  }

  Future<bool> updateTask({
    required String taskId,
    required String task,
    required String date,
    required String time,
    required String menuId,
    required bool isFinished,
  }) async {
    final token = storage.read('token');
    storage.write('taskId', taskId);

    logger.i('Task created with ID: $taskId, Token: $token');
    final url = Uri.parse(
        'https://app-project-9.onrender.com/api/task/updatetask/$taskId');

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'task': task,
          'date': date,
          'time': time,
          'menuId': menuId,
          'finished': isFinished,
        }),
      );

      logger.i('TaskRepository ::: updateTask:: $response');
    
      return response.statusCode == 200;
    } catch (e) {
      logger.e('Error updating task: $e');
      return false;
    }
  }

  Future<bool> deleteTask(String taskId) async {
    try {
      final token = storage.read('token');
      if (token == null || token.isEmpty) {
        throw Exception('Token not found');
      }

      logger.i('Attempting to delete task with ID: $taskId, Token: $token');

      final url = Uri.parse(
          'https://app-project-9.onrender.com/api/task/delete/$taskId');

      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      logger.i('TaskRepository ::: deleteTask:: $response');
    
      return response.statusCode == 200;
    } catch (e) {
      logger.e('Error updating task: $e');
      return false;
    }
  }


Future<void> requestExactAlarmPermission() async {
  if (defaultTargetPlatform == TargetPlatform.android) {
    const platform = MethodChannel('android_alarm_manager_plus');
    try {
      final int result = await platform.invokeMethod('canScheduleExactAlarms');
      if (result == 0) {
        final intent = AndroidIntent(
          action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM',
          flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
        );
        await intent.launch();
      }
    } on PlatformException catch (e) {
      debugPrint("Failed to request exact alarm permission: ${e.message}");
    }
  }
}


  Future<void> _scheduleNotification(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    String task,
    String date,
    String time,
  ) async {
    try {
      final DateTime scheduledDateTime =
        DateTime.parse('$date $time');
      final tz.TZDateTime scheduledTZDateTime =
          tz.TZDateTime.from(scheduledDateTime, tz.local);
      if (scheduledDateTime.isBefore(DateTime.now())) {
        logger.e('Cannot schedule notification in the past.');
        return;
      }

      logger.i('Scheduled date: ${scheduledDateTime.toIso8601String()}');

      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails('task_reminders', 'Task Reminders',
              channelDescription:
                  'Notifications for upcoming tasks and reminders.',
              importance: Importance.max,
              priority: Priority.high,
              actions: [
            AndroidNotificationAction(
              'finish_action',
              'Finish',
            ),
            AndroidNotificationAction(
              'edit_action',
              'Edit',
            ),
          ]);

      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        ' $task',
        ' $time',
        scheduledTZDateTime,
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: jsonEncode({
          'action': 'edit',
          'taskName': task,
          'date': date,
          "time": time,
        }),
      );

      logger.i(
          'Notification scheduled for task: $task at $scheduledDateTime');
    } catch (error) {
      logger.e('Error scheduling notification: $error');
    }
  }
}



