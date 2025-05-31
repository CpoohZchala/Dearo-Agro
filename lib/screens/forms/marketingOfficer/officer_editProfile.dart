import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class OfficerUpdateProfileScreen extends StatefulWidget {
  final String userId;
  const OfficerUpdateProfileScreen({super.key, required this.userId});

  @override
  _OfficerUpdateProfileScreenState createState() =>
      _OfficerUpdateProfileScreenState();
}

class _OfficerUpdateProfileScreenState
    extends State<OfficerUpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedCategory;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  final List<String> _categories = [
    "Farmer",
    "Marketing Officer",
    "Super Admin",
  ];

  bool _isLoading = false;
  String _responseMessage = '';

  Future<void> updateProfile() async {
    if (_nameController.text.trim().isEmpty &&
        _mobileController.text.trim().isEmpty &&
        _selectedCategory == null) {
      setState(() => _responseMessage = "Please fill at least one field.");
      return;
    }

    setState(() {
      _isLoading = true;
      _responseMessage = '';
    });

    try {
      final url = Uri.parse(
          'https://dearoagro-backend.onrender.com/api/officers/${widget.userId}');
      final body = json.encode({
        if (_nameController.text.trim().isNotEmpty)
          'fullName': _nameController.text.trim(),
        if (_selectedCategory != null) 'userType': _selectedCategory,
        if (_mobileController.text.trim().isNotEmpty)
          'mobileNumber': _mobileController.text.trim(),
      });

      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        setState(() => _responseMessage = '✅ Profile updated successfully!');
      } else {
        final errorData = jsonDecode(response.body);
        setState(() => _responseMessage =
            '❌ Update failed: ${errorData['message'] ?? 'Unknown error'}');
      }
    } catch (error) {
      setState(() => _responseMessage = '❗ Error: $error');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final inputStyle = GoogleFonts.poppins(fontSize: 16);
    final labelStyle =
        GoogleFonts.poppins(fontWeight: FontWeight.w500, color: Colors.black);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 235, 59, 0.8),
        title: Text(
          "Edit Profile",
          style: GoogleFonts.poppins(
              color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          ClipPath(
            clipper: ArcClipper(),
            child: Container(
              height: 100,
              color: const Color.fromRGBO(255, 235, 59, 0.8),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        labelStyle: labelStyle,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(255, 235, 59, 0.8),
                            width: 2,
                          ),
                        ),
                      ),
                      style: inputStyle,
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? 'Enter full name'
                              : null,
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: InputDecoration(
                        labelText: "User Type",
                        labelStyle: labelStyle,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(255, 235, 59, 0.8),
                            width: 2,
                          ),
                        ),
                      ),
                      items: _categories.map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category, style: inputStyle),
                        );
                      }).toList(),
                      validator: (value) =>
                          value == null ? 'Select a user type' : null,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCategory = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _mobileController,
                      decoration: InputDecoration(
                        labelText: 'Mobile Number',
                        labelStyle: labelStyle,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(255, 235, 59, 0.8),
                            width: 2,
                          ),
                        ),
                      ),
                      style: inputStyle,
                      keyboardType: TextInputType.phone,
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? 'Enter mobile number'
                              : null,
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton.icon(
                      onPressed: _isLoading ? null : updateProfile,
                      icon: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Icon(Icons.update, color: Colors.black),
                      label: Text(
                        "Update",
                        style: GoogleFonts.poppins(
                            fontSize: 16, color: Colors.black),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromRGBO(255, 235, 59, 0.8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      _responseMessage,
                      style: GoogleFonts.poppins(
                        color: _responseMessage.contains('✅')
                            ? Colors.green
                            : Colors.red,
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
