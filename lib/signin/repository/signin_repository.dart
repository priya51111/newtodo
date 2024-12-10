import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import 'package:newtodo/signin/model/signin_model.dart';

import 'package:shared_preferences/shared_preferences.dart';


class SigninRepository {
  final String apiUrl = 'https://app-project-9.onrender.com';
  final Logger logger = Logger();
  final box = GetStorage(); 

  Future<Map<String, dynamic>> signIn(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      throw Exception("Email and password are missing");
    }

    try {
      final response = await http.post(
        Uri.parse('$apiUrl/api/user'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      logger.i("API Response: ${response.statusCode} - ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = json.decode(response.body);
        final userMap = responseBody['data']['user'];
        final userId = userMap['_id'];

        box.write('userId', userId);
        box.write('email', email);
        logger.i("User ID saved: $userId");

        return responseBody;
      } else if (response.statusCode == 409) {
        throw Exception("User with this email already exists. Please sign in.");
      } else {
        throw Exception("Error: ${response.body}");
      }
    } catch (e) {
      logger.e("Error creating user: $e");
      throw Exception('Failed to create user');
    }
  }

  Future<Map<String, dynamic>> logIn(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      throw Exception("Email and password cannot be empty");
    }

    final response = await http.post(
      Uri.parse('$apiUrl/api/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    logger.i("Response Status Code: ${response.statusCode}");
    logger.i("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final token = data['token'];

      if (token.isEmpty) {
        throw Exception('Invalid credentials: token or userId is missing');
      }


      box.write('token', token);
      logger.i("Token saved: $token");

      return data;
    } else {
      throw Exception('Failed to sign in');
    }
  }
    Future<void> logOut() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('userId');
    await prefs.remove('token');

    logger.i("User logged out successfully. UserId and Token removed.");
  }

}
