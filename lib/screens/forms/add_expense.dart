import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';

class AddExpense extends StatefulWidget {
  final dynamic existingData;

  const AddExpense({super.key, this.existingData});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  final Dio _dio = Dio();
  final _storage = const FlutterSecureStorage();
  DateTime? _selectedDate;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _expenseController = TextEditingController();

  final int _maxChars = 50;
  int _charCount = 0;
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _descriptionController.addListener(_updateCharCount);
    _initializeFormData();
  }

  void _updateCharCount() {
    setState(() {
      _charCount = _descriptionController.text.length;
    });
  }

  void _initializeFormData() {
    if (widget.existingData != null) {
      _descriptionController.text = widget.existingData['description'] ?? '';
      _dateController.text = widget.existingData['addDate'] ?? '';
      _expenseController.text = widget.existingData['expense']?.toString() ?? '';
      _parseExistingDate();
    }
  }

  void _parseExistingDate() {
    if (widget.existingData['addDate'] != null) {
      try {
        final parts = widget.existingData['addDate'].split('-');
        if (parts.length == 3) {
          _selectedDate = DateTime(
            int.parse(parts[0]),
            int.parse(parts[1]),
            int.parse(parts[2]),
          );
        }
      } catch (e) {
        debugPrint("Error parsing date: $e");
      }
    }
  }

  @override
  void dispose() {
    _descriptionController.removeListener(_updateCharCount);
    _descriptionController.dispose();
    _dateController.dispose();
    _expenseController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = _formatDate(pickedDate);
      });
    }
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final userId = await _storage.read(key: "userId");
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User not logged in")),
        );
        return;
      }

      final url = widget.existingData != null
          ? "http://192.168.8.125:5000/api/eupdate"
          : "http://192.168.8.125:5000/api/esubmit";

      final data = {
        if (widget.existingData != null) "_id": widget.existingData['_id'],
        "memberId": userId,
        "addDate": _dateController.text,
        "description": _descriptionController.text,
        "expense": _expenseController.text,
      };

      final response = widget.existingData != null
          ? await _dio.put(url, data: data)
          : await _dio.post(url, data: data);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.data["message"])),
      );
      Navigator.pop(context, true);
    } on DioException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.response?.data['error'] ?? e.message}")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Unexpected error: ${e.toString()}")),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          ClipPath(
            clipper: ArcClipper(),
            child: Container(
              height: 190,
              color: const Color.fromRGBO(87, 164, 91, 0.8),
            ),
          ),
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            ),
          ),
          Positioned(
            top: 50,
            left: 50,
            child: Text(
              widget.existingData != null ? "Edit Cultivational Expense" : "New Cultivational Expense",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 180),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _dateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "Date",
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_month),
                          onPressed: _pickDate,
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty ? "Please select a date" : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _descriptionController,
                      maxLength: _maxChars,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: "Description about crop expense",
                        counterText: "",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty ? "Please enter description" : null,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text("$_charCount/$_maxChars", style: GoogleFonts.poppins()),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _expenseController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Expense Amount (Rs.)",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return "Please enter an amount";
                        if (double.tryParse(value) == null) return "Enter a valid number";
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(87, 164, 91, 0.8),
                          padding: const EdgeInsets.all(15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isSubmitting
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(
                                widget.existingData != null ? "Update" : "Submit",
                                style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
