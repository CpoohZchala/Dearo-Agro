import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class OrderService {
  static const String baseUrl =
      'https://dearoagro-backend.onrender.com/api/orders';

  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  static final FlutterSecureStorage storage = FlutterSecureStorage();

  static Future<String?> _getToken() async {
    return storage.read(key: 'authToken');
  }

  static Future<bool> createOrder({
    required List<Map<String, dynamic>> items,
    required String shippingAddress,
    required String paymentMethod,
  }) async {
    final token = await _getToken();

    if (token == null || token.isEmpty) {
      return false;
    }

    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          ...headers,
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'items': items,
          'shippingAddress': shippingAddress,
          'paymentMethod': paymentMethod,
        }),
      );

      print(
        'Create order response: ${response.statusCode} ${response.body}',
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Create order error: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>> fetchBuyerOrders() async {
    final token = await _getToken();

    if (token == null || token.isEmpty) {
      throw Exception('No authentication token found');
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/buyer'),
        headers: {
          ...headers,
          'Authorization': 'Bearer $token',
        },
      );

      print(
        'Fetch buyer orders response: ${response.statusCode} ${response.body}',
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded is Map<String, dynamic>) {
          return decoded;
        }

        return {
          'orders': decoded is List ? decoded : [],
        };
      }

      throw Exception(
        'Failed to fetch orders: ${response.statusCode} ${response.body}',
      );
    } catch (e) {
      throw Exception('Fetch buyer orders error: $e');
    }
  }
}