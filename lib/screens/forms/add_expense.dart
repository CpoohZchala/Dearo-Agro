import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';

class Addexpense extends StatefulWidget {
  final String memberId;
  final Map<String, dynamic>? expenseData;
  
  const Addexpense({
    super.key,
    required this.memberId,
    this.expenseData,
  });

  @override
  State<Addexpense> createState() => _AddexpenseState();
}

class _AddexpenseState extends State<Addexpense> {
  final _formKey = GlobalKey<FormState>();
  final Dio _dio = Dio();
  DateTime? _selectedDate;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final int _maxChars = 50;
  int _charCount = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    
    // Initialize with existing data if in edit mode
    if (widget.expenseData != null) {
      _dateController.text = widget.expenseData!['date'];
      _descriptionController.text = widget.expenseData!['description'];
      _amountController.text = widget.expenseData!['amount'].toString();
      _selectedDate = DateTime.parse(widget.expenseData!['date']);
    }
    
    _descriptionController.addListener(() {
      setState(() {
        _charCount = _descriptionController.text.length;
      });
    });

    // Configure Dio
    _dio.options.baseUrl = 'http://your-server-ip:3000/api/expenses';
    _dio.options.connectTimeout = const Duration(seconds: 5);
    _dio.options.receiveTimeout = const Duration(seconds: 5);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
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
        _dateController.text =
            "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final expenseData = {
        'memberId': widget.memberId,
        'date': _dateController.text,
        'description': _descriptionController.text,
        'amount': _amountController.text,
      };

      Response response;
      
      if (widget.expenseData == null) {
        // Create new expense
        response = await _dio.post('/submit', data: expenseData);
      } else {
        // Update existing expense
        response = await _dio.put(
          '/update/${widget.expenseData!['_id']}',
          data: expenseData,
        );
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.expenseData == null 
              ? "Expense added successfully!" 
              : "Expense updated successfully!")),
        );
        Navigator.pop(context, true);
      }
    } on DioException catch (e) {
      String errorMessage = "An error occurred";
      if (e.response != null) {
        errorMessage = e.response?.data['error'] ?? e.response?.statusMessage ?? errorMessage;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } finally {
      setState(() => _isLoading = false);
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
            top: 40,
            right: 20,
            child: Image.asset(
              "assets/icons/leaf.png",
              height: 35,
              width: 35,
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
                      decoration: InputDecoration(
                        labelText: "Date",
                        labelStyle: GoogleFonts.poppins(fontSize: 15),
                        suffixIcon: IconButton(
                          onPressed: _pickDate,
                          icon: const Icon(Icons.calendar_month),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      readOnly: true,
                      validator: (value) =>
                          value!.isEmpty ? "Please select a date" : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _descriptionController,
                      maxLength: _maxChars,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: "Description about Crop Expense ..",
                        labelStyle: GoogleFonts.poppins(fontSize: 15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        counterText: "",
                      ),
                      validator: (value) =>
                          value!.isEmpty ? "Please enter description" : null,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        "$_charCount/$_maxChars",
                        style: GoogleFonts.poppins(
                          color: Colors.green.shade700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Rs.",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter amount";
                        }
                        if (double.tryParse(value) == null) {
                          return "Enter a valid number";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(87, 164, 91, 0.8),
                        padding: const EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              widget.expenseData == null ? "Add" : "Update",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 15,
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