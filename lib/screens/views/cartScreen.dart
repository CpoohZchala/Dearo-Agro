import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class CartScreen extends StatelessWidget {
  final List<Map<String, dynamic>> cart;
  const CartScreen({required this.cart, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double total = cart.fold(
      0,
      (sum, item) => sum + (item['price'] as double) * (item['quantity'] ?? 1),
    );
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: cart.isEmpty
          ? const Center(child: Text('Cart is empty'))
          : ListView.builder(
              itemCount: cart.length,
              itemBuilder: (context, index) {
                final item = cart[index];
                return ListTile(
                  leading:
                      Image.asset(item['image'], width: screenWidth * 0.12),
                  title: Text(item['name'], style: GoogleFonts.poppins()),
                  subtitle: Text('Quantity: ${item['quantity'] ?? 1}',
                      style: GoogleFonts.poppins()),
                  trailing: Text(
                    '\$${((item['price'] as double) * (item['quantity'] ?? 1)).toStringAsFixed(2)}',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
      bottomNavigationBar: cart.isNotEmpty
          ? Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: ElevatedButton(
                onPressed: () async {
                  final response = await http.post(
                    Uri.parse(
                        'https://dearoagro-backend.onrender.com/api/order'),
                    headers: {'Content-Type': 'application/json'},
                    body: json.encode({
                      'buyerId': 'USER_ID',
                      'items': cart
                          .map((item) => {
                                'productId': item['id'],
                                'quantity': item['quantity'],
                              })
                          .toList(),
                      'totalAmount': total,
                    }),
                  );
                  if (response.statusCode == 201) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Order placed!')),
                    );
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Order failed: ${response.body}')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  textStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
                child: Text('Checkout (\$${total.toStringAsFixed(2)})'),
              ),
            )
          : null,
    );
  }
}
