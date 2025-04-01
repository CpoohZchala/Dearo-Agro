import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _baseUrl = "http://192.168.8.125:5000/api";
  static const String _tokenKey = 'auth_token';

  
  // Save token to SharedPreferences
 static Future<void> saveToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token);
      print('Token saved successfully'); // Debug print
    } catch (e) {
      print('Error saving token: $e'); // Debug print
      throw Exception('Failed to save authentication token');
    }
  }

  // Get token from SharedPreferences
   static Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);
      print('Retrieved token: ${token != null ? 'exists' : 'null'}'); // Debug print
      return token;
    } catch (e) {
      print('Error getting token: $e'); // Debug print
      return null;
    }
  }

  // Remove token (for logout)
  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  // Fetch user profile using JWT token
  static Future<Map<String, dynamic>> fetchUserProfile() async {
    final token = await getToken();
    if (token == null) {
      throw Exception('No authentication token found. Please login again.');
    }

    final response = await http.get(
      Uri.parse("$_baseUrl/users/profile"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 401) {
      throw Exception('Session expired. Please login again.');
    } else {
      throw Exception('Failed to load user profile: ${response.statusCode}');
    }
  }
}