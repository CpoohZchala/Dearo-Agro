import 'dart:convert'; // Add this import for decoding the JWT
import 'package:farmeragriapp/api/order_api.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final OrderService _orderService =
      OrderService('https://dearoagro-backend.onrender.com/api');
  List<dynamic> orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    final token = await storage.read(key: "authToken");
    print('Fetching orders with token: $token');

    if (token != null) {
      try {
        // Decode the JWT token to extract the user ID
        final payload = json.decode(utf8.decode(
            base64Url.decode(base64Url.normalize(token.split('.')[1]))));
        final userId = payload['id'];
        print('Decoded payload: $payload');
        print('User ID from token: $userId');

        final fetchedOrders = await _orderService.fetchBuyerOrders(token);
        print('Raw Response: $fetchedOrders');
        if (fetchedOrders.isEmpty) {
          print('No orders found for the user.');
        }
        setState(() {
          orders = fetchedOrders;
          isLoading = false;
        });
      } catch (e) {
        print('Error fetching orders: $e');
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch orders: $e')),
        );
      }
    } else {
      print('No auth token found');
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please sign in to view orders')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.jpg', // Replace with your image path
              fit: BoxFit.cover,
            ),
          ),
          // Foreground Content
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : orders.isEmpty
                  ? Center(
                      child: Text('No orders found',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          )))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipPath(
                          clipper: ArcClipper(),
                          child: Container(
                            height: 150,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color.fromARGB(255, 28, 81, 38)
                                      .withOpacity(0.8),
                                  const Color.fromARGB(255, 8, 11, 4)
                                      .withOpacity(0.8),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'My Orders',
                                style: GoogleFonts.poppins(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.yellow,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: orders.length,
                            itemBuilder: (context, index) {
                              final order = orders[index];
                              return Card(
                                elevation: 4,
                                margin: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        const Color.fromARGB(255, 7, 64, 7)
                                            .withOpacity(1.0),
                                        const Color.fromARGB(255, 237, 239, 236)
                                            .withOpacity(0.9),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      'Order ID: ${order['_id']}',
                                      style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    subtitle: Text(
                                      'Total: Rs.${order['totalAmount']}',
                                      style: GoogleFonts.poppins(
                                          fontSize: 14, color: Colors.white70),
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () async {
                                        final token = await storage.read(
                                            key: "authToken");
                                        if (token != null) {
                                          try {
                                            await _orderService.deleteOrder(
                                                order['_id'], token);
                                            setState(() {
                                              orders.removeAt(index);
                                            });
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content: Text(
                                                      'Order deleted successfully')),
                                            );
                                          } catch (e) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      'Failed to delete order: $e')),
                                            );
                                          }
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    'Please sign in to delete orders')),
                                          );
                                        }
                                      },
                                    ),
                                    onTap: () async {
                                      final token =
                                          await storage.read(key: "authToken");
                                      if (token != null) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                OrderDetailsScreen(
                                              orderId: order['_id'],
                                              authToken: token,
                                            ),
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Please sign in to view order details')),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
        ],
      ),
    );
  }
}

class OrderDetailsScreen extends StatefulWidget {
  final String orderId;
  final String authToken;

  const OrderDetailsScreen(
      {Key? key, required this.orderId, required this.authToken})
      : super(key: key);

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final OrderService _orderService =
      OrderService('https://dearoagro-backend.onrender.com/api');
  Map<String, dynamic>? orderDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOrderDetails();
  }

  Future<void> _fetchOrderDetails() async {
    try {
      final details = await _orderService.fetchOrderDetails(
          widget.orderId, widget.authToken);
      setState(() {
        orderDetails = details;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch order details: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.jpg',
              fit: BoxFit.cover,
            ),
          ),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : orderDetails == null
                  ? const Center(child: Text('Order details not found'))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipPath(
                          clipper: ArcClipper(),
                          child: Container(
                            height: 150,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color.fromARGB(255, 28, 81, 38)
                                      .withOpacity(0.8),
                                  const Color.fromARGB(255, 8, 11, 4)
                                      .withOpacity(0.8),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Center(
                              child: Text('Order Details',
                                  style: GoogleFonts.poppins(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.yellow,
                                  )),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Order Details Content
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(16.0),
                            child: Card(
                              elevation: 2,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(
                                      0.5), // Semi-transparent background
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Order ID: ${orderDetails!['_id']}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Total: Rs.${orderDetails!['totalAmount']}',
                                      style: GoogleFonts.poppins(
                                          fontSize: 16, color: Colors.yellow),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Shipping Address: ${orderDetails!['shippingAddress']}',
                                      style: GoogleFonts.poppins(fontSize: 16),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Items:',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    if (orderDetails != null &&
                                        orderDetails!.containsKey('items'))
                                      ...orderDetails!['items']
                                          .map<Widget>((item) {
                                        return Card(
                                          elevation: 2,
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 8),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                      255, 145, 242, 150)
                                                  .withOpacity(
                                                      0.1), // Semi-transparent background
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: ListTile(
                                              title: Text(
                                                item['name'],
                                                style: GoogleFonts.poppins(
                                                    fontSize: 14),
                                              ),
                                              subtitle: Text(
                                                'Quantity: ${item['quantity']}',
                                                style: GoogleFonts.poppins(
                                                    fontSize: 12),
                                              ),
                                              trailing: Text(
                                                '\$${item['price']}',
                                                style: GoogleFonts.poppins(
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
        ],
      ),
    );
  }
}
