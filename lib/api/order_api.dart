import 'dart:convert';
import 'package:farmeragriapp/api/cart_api.dart';
import 'package:http/http.dart' as http;

class OrderService {
  final String baseUrl;

  OrderService(this.baseUrl);

  Future<void> createOrder(
      Map<String, dynamic> orderData, String authToken) async {
    final url = Uri.parse('$baseUrl/orders');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: jsonEncode(orderData),
    );

    // Accept both 200 and 201 as success status codes
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to create order: ${response.body}');
    }
  }

  Future<List<dynamic>> fetchBuyerOrders(String authToken) async {
    final url = Uri.parse('$baseUrl/orders');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch orders: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> fetchOrderDetails(
      String orderId, String authToken) async {
    final url = Uri.parse('$baseUrl/orders/$orderId');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch order details: ${response.body}');
    }
  }

  Future<void> deleteOrder(String orderId, String authToken) async {
    final url = Uri.parse('$baseUrl/orders/$orderId');
    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete order: ${response.body}');
    }
  }
}
