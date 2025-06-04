import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CartApi {
  static const String baseUrl =
      'https://dearoagro-backend.onrender.com/api/cart';
  List<Map<String, dynamic>> cartItems = [];
  double totalAmount = 0.0;
  bool isLoading = false;

  static Future<Map<String, dynamic>> getCart(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load cart');
    }
  }

  static Future<bool> addToCart(
      String token, String productId, int quantity) async {
    print(
        'Debug: productId=$productId, quantity=$quantity');

    if (productId.isEmpty) {
      print('Invalid productId: productId is empty');
      return false;
    }
    if (quantity <= 0) {
      print('Invalid quantity: quantity must be greater than 0');
      return false;
    }

    try {
      print('Adding to cart: productId=$productId, quantity=$quantity');
      final response = await http.post(
        Uri.parse('$baseUrl/add'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'productId': productId,
          'quantity': quantity,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print(
            'Failed to add to cart: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error adding to cart: $e');
      return false;
    }
  }

  static Future<bool> updateCartItem(
      String token, String itemId, int quantity) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/update/$itemId'), 
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'quantity': quantity,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> removeFromCart(String token, String itemId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/remove/$itemId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> clearCart(String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    return response.statusCode == 200;
  }

  static Future<Map<String, dynamic>?> checkout(
      String token, String shippingAddress, String paymentMethod) async {
    try {
      final response = await http.post(
        Uri.parse('https://dearoagro-backend.onrender.com/api/orders'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'shippingAddress': shippingAddress,
          'paymentMethod': paymentMethod,
        }),
      );

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      print('Error during checkout: $e');
      return null;
    }
  }
}

final storage = FlutterSecureStorage();

List<Map<String, dynamic>> cartItems = [];
double totalAmount = 0.0;
bool isLoading = false;

Future<void> fetchCartItems(
    BuildContext context, void Function(void Function()) setState) async {
  try {
    final token = await storage.read(key: "authToken");
    if (token == null) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please sign in to view cart')),
      );
      return;
    }

    final cartData = await CartApi.getCart(token);
    setState(() {
      cartItems = List<Map<String, dynamic>>.from(cartData['items'] ?? []);
      totalAmount = (cartData['total'] ?? 0.0).toDouble();
      isLoading = false;
    });
  } catch (e) {
    setState(() => isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Failed to load cart items')),
    );
  }
  
}
