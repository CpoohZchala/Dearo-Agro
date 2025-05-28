import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductApi {
  static Future<List<Product>> fetchProducts() async {
    final response = await http.get(
      Uri.parse(
          'https://dearoagro-backend.onrender.com/api/'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // If backend returns a single object, wrap in a list
      final List<dynamic> productsList = data is List ? data : [data];
      return productsList.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}
