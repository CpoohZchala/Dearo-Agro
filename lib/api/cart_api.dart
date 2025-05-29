import 'dart:convert';
import 'package:http/http.dart' as http;

class CartApi {
  static const String baseUrl =
      'https://dearoagro-backend.onrender.com/api/cart';

  // Add item to cart
  static Future<bool> addToCart(
      String token, String productId, int quantity) async {
    final response = await http.post(
      Uri.parse('$baseUrl/add'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'productId': productId, 'quantity': quantity}),
    );
    print('Add to cart status: ${response.statusCode}');
    print('Add to cart body: ${response.body}');
    return response.statusCode == 201;
  }

  // Get cart contents
  static Future<Map<String, dynamic>?> getCart(String token) async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      
      print('GET CART STATUS: ${response.statusCode}');
      print('GET CART BODY: ${response.body}');
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 500) {
        // Handle server errors more gracefully
        print('Server error details: ${response.body}');
        return {'items': [], 'totalPrice': 0};
      }
      return null;
    } catch (e) {
      print('Network error fetching cart: $e');
      return null;
    }
}

  // Remove item from cart
  static Future<bool> removeFromCart(String token, String itemId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/remove/$itemId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return response.statusCode == 200;
  }

  // Clear cart
  static Future<bool> clearCart(String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/clear'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return response.statusCode == 200;
  }
}
