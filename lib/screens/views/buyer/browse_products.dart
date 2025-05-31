import 'dart:convert';
import 'package:farmeragriapp/api/product_api.dart';
import 'package:farmeragriapp/api/cart_api.dart';
import 'package:farmeragriapp/models/product.dart';
import 'package:farmeragriapp/screens/views/buyer/cartScreen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class BrowseProductsScreen extends StatefulWidget {
  const BrowseProductsScreen({Key? key}) : super(key: key);

  @override
  State<BrowseProductsScreen> createState() => _BrowseProductsScreenState();
}

class _BrowseProductsScreenState extends State<BrowseProductsScreen> {
  List<Product> products = [];
  bool isLoading = true;

  final List<String> categories = ['All', 'Vegetables', 'Fruits', 'Seeds'];
  String selectedCategory = 'All';

  final List<Map<String, dynamic>> cart = [];
  final Map<String, int> selectedQuantities = {};

  final storage = FlutterSecureStorage();

  void addToCart(Map<String, dynamic> product) {
    int quantity = selectedQuantities[product['id']] ?? 1;
    setState(() {
      cart.add({
        ...product,
        'quantity': quantity,
      });
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product['name']} (x$quantity) added to cart!')),
    );
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
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final fetchedProducts = await ProductApi.fetchProducts();
      setState(() {
        products = fetchedProducts;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load products')),
      );
    }
  }

  Future<void> addProductToCart(Product product) async {
    int quantity = selectedQuantities[product.id] ?? 1;
    final token = await storage.read(key: "authToken");
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please sign in to add to cart')),
      );
      return;
    }
    final success = await CartApi.addToCart(token, product.id, quantity);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${product.name} (x$quantity) added to cart!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add to cart')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth < 600
        ? 2
        : screenWidth < 900
            ? 3
            : 4;
    final imageHeight = screenWidth / (crossAxisCount * 1.2);

    final filteredProducts = selectedCategory == 'All'
        ? products
        : products
            .where((p) =>
                p.category.toLowerCase() == selectedCategory.toLowerCase())
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Browse Products', style: GoogleFonts.poppins()),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: goToCart,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(
                      vertical: 8, horizontal: screenWidth * 0.04),
                  child: Row(
                    children: categories.map((cat) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ChoiceChip(
                          label: Text(cat),
                          selected: selectedCategory == cat,
                          onSelected: (_) {
                            setState(() {
                              selectedCategory = cat;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: fetchProducts,
                    child: GridView.builder(
                      padding: EdgeInsets.all(screenWidth * 0.04),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: screenWidth * 0.04,
                        crossAxisSpacing: screenWidth * 0.04,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];
                        final productId = product.id;
                        int quantity = selectedQuantities[productId] ?? 1;
                        return Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(screenWidth * 0.02),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Image.network(
                                    product.image,
                                    fit: BoxFit.contain,
                                    height: imageHeight,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(Icons.broken_image),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(product.name,
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold)),
                                Text('\$${product.price}',
                                    style: GoogleFonts.poppins(
                                        color: Colors.green)),
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove),
                                      onPressed: quantity > 1
                                          ? () {
                                              setState(() {
                                                selectedQuantities[productId] =
                                                    quantity - 1;
                                              });
                                            }
                                          : null,
                                    ),
                                    Text('$quantity',
                                        style: GoogleFonts.poppins()),
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () {
                                        setState(() {
                                          selectedQuantities[productId] =
                                              quantity + 1;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                ElevatedButton.icon(
                                  onPressed: () => addProductToCart(product),
                                  icon: const Icon(Icons.add_shopping_cart),
                                  label: const Text('Add to Cart'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green[700],
                                    foregroundColor: Colors.white,
                                    minimumSize:
                                        const Size(double.infinity, 36),
                                    textStyle: GoogleFonts.poppins(),
                                  ),
                                ),
                                const SizedBox(height: 6),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
