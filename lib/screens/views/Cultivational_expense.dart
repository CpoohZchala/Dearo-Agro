import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:farmeragriapp/screens/forms/addexpense.dart';

class CultivationalExpense extends StatefulWidget {
  const CultivationalExpense({super.key});

  @override
  State<CultivationalExpense> createState() => _CultivationalExpenseState();
}

class _CultivationalExpenseState extends State<CultivationalExpense> {
  final Dio _dio = Dio();
  final _storage = const FlutterSecureStorage();
  List<dynamic> _expenses = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchExpenses();
  }

  Future<void> _fetchExpenses() async {
    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });

      final userId = await _storage.read(key: "userId");
      if (userId == null) {
        throw Exception("User ID not found");
      }

      final response = await _dio.get(
        "http://192.168.8.125:5000/api/efetch/$userId",
        options: Options(
          receiveTimeout: const Duration(seconds: 10),
          sendTimeout: const Duration(seconds: 10),
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          _expenses = response.data is List ? response.data : [];
          _isLoading = false;
        });
      } else {
        throw Exception("Failed to load expenses: ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch expenses: ${e.toString()}")),
      );
    }
  }

  Future<void> _deleteExpense(String id) async {
    try {
      final itemToRemove = _expenses.firstWhere((exp) => exp['_id'] == id);
      setState(() => _expenses.removeWhere((exp) => exp['_id'] == id));

      final response = await _dio.delete(
        "http://192.168.8.125:5000/api/edelete/$id",
        options: Options(
          receiveTimeout: const Duration(seconds: 10),
          sendTimeout: const Duration(seconds: 10),
        ),
      );

      if (response.statusCode != 200) {
        setState(() => _expenses.add(itemToRemove));
        throw Exception("Server deletion failed");
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.data["message"] ?? "Expense deleted")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete: ${e.toString()}")),
      );
    }
  }

  Future<void> _navigateToAddExpense() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Addexpense()),
    );
    if (result == true) {
      await _fetchExpenses();
    }
  }

  Future<void> _navigateToEditExpense(Map<String, dynamic> expense) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Addexpense(),
      ),
    );
    if (result == true) {
      await _fetchExpenses();
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddExpense,
        backgroundColor: const Color.fromRGBO(87, 164, 91, 0.8),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          // Header
          ClipPath(
            clipper: ArcClipper(),
            child: Container(
              height: 170,
              color: const Color.fromRGBO(87, 164, 91, 0.8),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Text(
                    "Cultivation Expenses",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Expense List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _hasError
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error, size: 50, color: Colors.red),
                            const SizedBox(height: 16),
                            Text(
                              "Failed to load expenses",
                              style: GoogleFonts.poppins(fontSize: 16),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _fetchExpenses,
                              child: Text("Retry", style: GoogleFonts.poppins()),
                            ),
                          ],
                        ),
                      )
                    : _expenses.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.receipt_long, size: 50, color: Colors.grey),
                                const SizedBox(height: 16),
                                Text(
                                  "No expenses recorded",
                                  style: GoogleFonts.poppins(fontSize: 16),
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _fetchExpenses,
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              itemCount: _expenses.length,
                              itemBuilder: (context, index) {
                                final expense = _expenses[index];
                                return _buildExpenseCard(
                                  expense['date'] ?? 'No date',
                                  expense['description'] ?? 'No description',
                                  expense['amount']?.toDouble() ?? 0.0,
                                  expense['_id'],
                                  expense,
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseCard(String date, String description, double amount, String id, Map<String, dynamic> expense) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(
          color: Color.fromRGBO(87, 164, 91, 0.8),
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "Rs. ${amount.toStringAsFixed(2)}",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.green[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.normal,
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => _showDeleteConfirmation(id),
                  icon: const Icon(
                    Icons.delete,
                    color: Color.fromRGBO(87, 164, 91, 0.8),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => _navigateToEditExpense(expense), // ✅ FIXED
                  icon: const Icon(
                    Icons.edit,
                    color: Color.fromRGBO(87, 164, 91, 0.8),
                    size: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Confirm Delete",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          "Are you sure you want to delete this expense?",
          style: GoogleFonts.poppins(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: GoogleFonts.poppins(
                color: const Color.fromRGBO(87, 164, 91, 0.8),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              _deleteExpense(id);
              Navigator.pop(context);
            },
            child: Text(
              "Delete",
              style: GoogleFonts.poppins(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
