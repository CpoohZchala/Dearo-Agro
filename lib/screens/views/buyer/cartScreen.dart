import 'package:farmeragriapp/screens/views/buyer/checkout_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:farmeragriapp/api/cart_api.dart';
import 'package:farmeragriapp/models/product.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String, dynamic>> cartItems = [];
  bool isLoading = true;
  double totalAmount = 0.0;
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    try {
      final token = await storage.read(key: "authToken");
      if (token != null) {
        final cartData = await CartApi.getCart(token);
        setState(() {
          cartItems = List<Map<String, dynamic>>.from(cartData['items']);
          totalAmount = cartData['total']?.toDouble() ?? 0.0;
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please sign in to view cart')),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load cart items')),
      );
    }
  }

  Future<void> updateCartItemQuantity(String itemId, int newQuantity) async {
    try {
      final token = await storage.read(key: "authToken");
      if (token != null) {
        final success =
            await CartApi.updateCartItem(token, itemId, newQuantity);
        if (success) {
          await fetchCartItems(); // Refresh cart data
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to update quantity')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error updating cart')),
      );
    }
  }

  Future<void> removeFromCart(String itemId) async {
    try {
      final token = await storage.read(key: "authToken");
      if (token != null) {
        final success = await CartApi.removeFromCart(token, itemId);
        if (success) {
          await fetchCartItems(); // Refresh cart data
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Item removed from cart')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to remove item')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error removing item')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Your Cart', style: GoogleFonts.poppins()),
        actions: [
          if (cartItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                final token = await storage.read(key: "authToken");
                if (token != null) {
                  final success = await CartApi.clearCart(token);
                  if (success) {
                    setState(() {
                      cartItems = [];
                      totalAmount = 0.0;
                    });
                  }
                }
              },
              tooltip: 'Clear Cart',
            ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : cartItems.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.shopping_cart_outlined, size: 64),
                      const SizedBox(height: 16),
                      Text('Your cart is empty',
                          style: GoogleFonts.poppins(fontSize: 18)),
                      const SizedBox(height: 8),
                      Text('Browse products to add items to your cart',
                          style: GoogleFonts.poppins()),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartItems[index];
                          final productData = item['product'];

                          // Add null check for productData
                          final product = productData != null
                              ? Product.fromJson(productData)
                              : null;

                          final quantity = item['quantity'] ?? 0;
                          final price = item['price'] ?? 0.0;
                          final itemTotal = price * quantity;

                          return Card(
                            color: Colors.green[50],
                            margin: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: product?.image != null
                                        ? Image.network(
                                            product!.image,
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error,
                                                    stackTrace) =>
                                                const Icon(Icons.broken_image),
                                          )
                                        : const Icon(Icons.image_not_supported,
                                            size: 80),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product?.name ?? 'Unknown Product',
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text('Rs.${price.toStringAsFixed(2)}',
                                            style: GoogleFonts.poppins()),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                IconButton(
                                                  icon:
                                                      const Icon(Icons.remove),
                                                  onPressed: quantity > 1
                                                      ? () =>
                                                          updateCartItemQuantity(
                                                              item['_id'] ?? '',
                                                              quantity - 1)
                                                      : null,
                                                ),
                                                Text('$quantity',
                                                    style:
                                                        GoogleFonts.poppins()),
                                                IconButton(
                                                  icon: const Icon(Icons.add),
                                                  onPressed: () =>
                                                      updateCartItemQuantity(
                                                          item['_id'] ?? '',
                                                          quantity + 1),
                                                ),
                                              ],
                                            ),
                                            Text(
                                                '\$${itemTotal.toStringAsFixed(2)}',
                                                style: GoogleFonts.poppins(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () =>
                                        removeFromCart(item['_id'] ?? ''),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, -3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Subtotal:',
                                style: GoogleFonts.poppins(
                                    fontSize: 16, color: Colors.black),
                              ),
                              Text('Rs.${totalAmount.toStringAsFixed(2)}',
                                  style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors
                                    .black, // Set the background color to black
                              ),
                              onPressed: () async {
                                final token = await storage.read(
                                    key: "authToken"); // Retrieve auth token
                                if (token == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Please sign in to proceed')),
                                  );
                                  return;
                                }

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CheckoutScreen(
                                      onCheckout: (shippingAddress,
                                          paymentMethod) async {
                                        try {
                                          final result = await CartApi.checkout(
                                            token,
                                            shippingAddress,
                                            paymentMethod,
                                          );
                                          if (result != null) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content: Text(
                                                      'Order placed successfully')),
                                            );
                                            Navigator.pop(
                                                context); // Close the checkout screen
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content: Text(
                                                      'Failed to place order')),
                                            );
                                          }
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    'Error: ${e.toString()}')),
                                          );
                                        }
                                      },
                                      authToken:
                                          token, // Pass the auth token to CheckoutScreen
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                'Checkout',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  color: Colors
                                      .yellow, // Ensure text color contrasts with black background
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}
