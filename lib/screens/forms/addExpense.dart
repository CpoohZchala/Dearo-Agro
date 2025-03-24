import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:google_fonts/google_fonts.dart';

class Addexpense extends StatefulWidget {
  const Addexpense({super.key});

  @override
  State<Addexpense> createState() => _NewUpdateFormState();
}

class _NewUpdateFormState extends State<Addexpense> {
  final _formKey = GlobalKey<FormState>(); // Form Key for Validation
  DateTime? _selectedDate;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final int _maxChars = 50;
  int _charCount = 0;

  @override
  void initState() {
    super.initState();
    _descriptionController.addListener(() {
      setState(() {
        _charCount = _descriptionController.text.length;
      });
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, proceed with expense submission
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Expense Added Successfully")),
      );
      // Reset Form
      _dateController.clear();
      _amountController.clear();
      _descriptionController.clear();
      setState(() {
        _charCount = 0;
        _selectedDate = null;
      });
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
              onPressed: () {
                Navigator.pop(context);
              },
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
                key: _formKey, // Assign Form Key
                child: Column(
                  children: <Widget>[
                    // Date Picker Field
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

                    // Amount Field
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
                    const SizedBox(height: 10),

                    // Description Field
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
                    const SizedBox(height: 30),

                    // Submit Button
                    ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(87, 164, 91, 0.8),
                        padding: const EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "Add",
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
