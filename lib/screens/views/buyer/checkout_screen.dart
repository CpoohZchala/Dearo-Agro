import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:farmeragriapp/api/order_api.dart';

class CheckoutScreen extends StatefulWidget {
  final List<dynamic> cartItems;

  const CheckoutScreen({
    super.key,
    required this.cartItems,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController _addressController = TextEditingController();

  String _selectedPaymentMethod = 'COD';
  bool _isPlacingOrder = false;

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  String _getStringValue(
      dynamic item,
      List<String> keys, {
        String fallback = '',
      }) {
    if (item is! Map) return fallback;

    for (final key in keys) {
      final value = item[key];

      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString();
      }
    }

    return fallback;
  }

  double _getDoubleValue(dynamic item, List<String> keys) {
    if (item is! Map) return 0;

    for (final key in keys) {
      final value = item[key];

      if (value == null) continue;

      if (value is num) {
        return value.toDouble();
      }

      final parsed = double.tryParse(value.toString());

      if (parsed != null) {
        return parsed;
      }
    }

    return 0;
  }

  String _formatPrice(double value) {
    if (value % 1 == 0) {
      return value.toInt().toString();
    }

    return value.toStringAsFixed(2);
  }

  String _getItemName(dynamic item) {
    return _getStringValue(
      item,
      [
        'name',
        'cropName',
        'productName',
        'title',
      ],
      fallback: 'Product',
    );
  }

  String _getItemImage(dynamic item) {
    return _getStringValue(
      item,
      [
        'image',
        'imageUrl',
        'productImage',
      ],
    );
  }

  String _getStockId(dynamic item) {
    if (item is! Map) return '';

    final stockId = item['stockId'];

    if (stockId != null) {
      if (stockId is Map) {
        return stockId['_id']?.toString() ??
            stockId['id']?.toString() ??
            '';
      }

      return stockId.toString();
    }

    final stock = item['stock'];

    if (stock is Map) {
      return stock['_id']?.toString() ?? stock['id']?.toString() ?? '';
    }

    return _getStringValue(
      item,
      [
        'stock_id',
        'stockID',
      ],
    );
  }

  double _getQuantity(dynamic item) {
    return _getDoubleValue(
      item,
      [
        'quantity',
        'qty',
        'amount',
        'selectedQuantity',
      ],
    );
  }

  double _getPrice(dynamic item) {
    return _getDoubleValue(
      item,
      [
        'price',
        'pricePerKg',
        'currentPrice',
        'unitPrice',
      ],
    );
  }

  double _getItemTotal(dynamic item) {
    final existingTotal = _getDoubleValue(
      item,
      [
        'total',
        'totalPrice',
        'itemTotal',
      ],
    );

    if (existingTotal > 0) {
      return existingTotal;
    }

    return _getQuantity(item) * _getPrice(item);
  }

  double _getCartTotal() {
    double total = 0;

    for (final item in widget.cartItems) {
      total += _getItemTotal(item);
    }

    return total;
  }

  List<Map<String, dynamic>> _buildOrderItems() {
    return widget.cartItems.map((item) {
      return {
        'stockId': _getStockId(item),
        'name': _getItemName(item),
        'image': _getItemImage(item),
        'quantity': _getQuantity(item),
        'price': _getPrice(item),
      };
    }).toList();
  }

  Future<void> _placeOrder() async {
    final shippingAddress = _addressController.text.trim();

    if (widget.cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your cart is empty')),
      );
      return;
    }

    if (shippingAddress.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your delivery address')),
      );
      return;
    }

    final orderItems = _buildOrderItems();

    final hasInvalidItem = orderItems.any((item) {
      final stockId = item['stockId'].toString();
      final quantity = item['quantity'] as double;
      final price = item['price'] as double;

      return stockId.isEmpty || quantity <= 0 || price <= 0;
    });

    if (hasInvalidItem) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Some cart items have missing stock, quantity, or price details.',
          ),
        ),
      );
      return;
    }

    setState(() {
      _isPlacingOrder = true;
    });

    try {
      final isSuccess = await OrderService.createOrder(
        items: orderItems,
        shippingAddress: shippingAddress,
        paymentMethod: _selectedPaymentMethod,
      );

      if (!mounted) return;

      if (!isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to place order. Please try again.'),
          ),
        );
        return;
      }

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              'Order Placed!',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                color: Colors.green.shade800,
              ),
            ),
            content: Text(
              'Your order was placed successfully. We will contact you soon.',
              style: GoogleFonts.poppins(),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  Navigator.pop(context, true);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  'OK',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          );
        },
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to place order: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isPlacingOrder = false;
        });
      }
    }
  }

  Widget _buildDefaultImage() {
    return Container(
      width: 58,
      height: 58,
      color: Colors.green.shade50,
      child: Icon(
        Icons.eco_outlined,
        color: Colors.green.shade700,
        size: 29,
      ),
    );
  }

  Widget _buildOrderItem(dynamic item) {
    final name = _getItemName(item);
    final image = _getItemImage(item);
    final quantity = _getQuantity(item);
    final price = _getPrice(item);
    final itemTotal = _getItemTotal(item);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: image.isNotEmpty
                ? Image.network(
              image,
              width: 58,
              height: 58,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _buildDefaultImage(),
            )
                : _buildDefaultImage(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_formatPrice(quantity)} kg × Rs. ${_formatPrice(price)}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Rs. ${_formatPrice(itemTotal)}',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Colors.orange.shade900,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = _getCartTotal();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Checkout',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 130),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Order Items',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),

              ...widget.cartItems.map(_buildOrderItem),

              const SizedBox(height: 16),

              Text(
                'Shipping Address',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),

              TextField(
                controller: _addressController,
                minLines: 3,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Enter your complete delivery address',
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(
                    Icons.location_on_outlined,
                    color: Colors.green.shade700,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 22),

              Text(
                'Payment Method',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: DropdownButton<String>(
                  value: _selectedPaymentMethod,
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem<String>(
                      value: 'COD',
                      child: Text('Cash on Delivery'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value == null) return;

                    setState(() {
                      _selectedPaymentMethod = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    'Total Amount',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Rs. ${_formatPrice(total)}',
                    style: GoogleFonts.poppins(
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                      color: Colors.green.shade800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isPlacingOrder ? null : _placeOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.green.shade200,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                  child: _isPlacingOrder
                      ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                      : Text(
                    'Confirm & Place Order',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}