import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:farmeragriapp/api/cart_api.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final storage = FlutterSecureStorage();
  Map<String, dynamic>? cartData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCart();
  }

  Future<void> fetchCart() async {
    try {
      final token = await storage.read(key: "authToken");
      print('Token: $token');
      if (token != null) {
        final data = await CartApi.getCart(token);
        print('RAW CART RESPONSE: ${jsonEncode(data)}');
        setState(() {
          cartData = data;
          isLoading = false;
        });
      } else {
        print('No token found');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching cart: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void goToCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CartScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final items = (cartData?['items'] as List<dynamic>?)?.where((item) {
          return item['productId'] != null && item['productId'] is Map;
        }).toList() ??
        [];

    double total = items.fold(0, (sum, item) {
      final product = item['productId'] as Map;
      final price = (product['price'] as num?)?.toDouble() ?? 0;
      final quantity = (item['quantity'] as num?)?.toInt() ?? 1;
      return sum + (price * quantity);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: items.isEmpty
          ? const Center(child: Text('Cart is empty'))
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final product = item['productId'] as Map;
                return ListTile(
                  leading: product['image'] != null
                      ? Image.network(product['image'],
                          width: screenWidth * 0.12)
                      : const Icon(Icons.shopping_cart),
                  title: Text(
                    product['name'] ?? 'Unknown Product',
                    style: GoogleFonts.poppins(),
                  ),
                  subtitle: Text(
                    'Quantity: ${item['quantity'] ?? 1}',
                    style: GoogleFonts.poppins(),
                  ),
                  trailing: Text(
                    '\$${((product['price'] as num?)?.toDouble() ?? 0 * (item['quantity'] ?? 1)).toStringAsFixed(2)}',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
      bottomNavigationBar: items.isNotEmpty
          ? Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: ElevatedButton.icon(
                onPressed: () {
                  // Implement checkout logic here
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Checkout not implemented')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  textStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
                label: Text('Checkout (\$${total.toStringAsFixed(2)})'),
                icon: const Icon(Icons.payment),
              ),
            )
          : null,
    );
  }
}
