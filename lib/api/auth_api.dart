import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class AuthApi {
  static const String baseUrl = 'https://dearoagro-backend.onrender.com/api/auth';

  static Future<http.Response> signUp(User user) async {
    final url = Uri.parse('$baseUrl/signup');

    return await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(user.toJson()),
    );
  }
   static Future<http.Response> signIn(User user) async {
    final url = Uri.parse('$baseUrl/signin');
    return await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(user.toJson()),
    );
  }
}
