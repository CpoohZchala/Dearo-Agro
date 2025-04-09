import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdateProfileScreen extends StatefulWidget {
  final String userId;

  UpdateProfileScreen({required this.userId});

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _userTypeController = TextEditingController();
  final TextEditingController _profileImageController = TextEditingController();

  bool _isLoading = false;
  String _responseMessage = '';

  Future<void> updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _responseMessage = '';
    });

    final url = Uri.parse('http://192.168.51.201:5000/api/users/${widget.userId}');
    final body = json.encode({
      'fullName': _nameController.text.trim(),
      'userType': _userTypeController.text.trim(),
      'profileImage': _profileImageController.text.trim(),
    });

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        setState(() => _responseMessage = '✅ Profile updated successfully!');
      } else {
        setState(() => _responseMessage = '❌ Update failed. Try again.');
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
    final labelStyle = GoogleFonts.poppins(fontWeight: FontWeight.w500);

    return Scaffold(
      appBar: AppBar(
        title: Text('Update Profile', style: GoogleFonts.poppins()),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Full Name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  labelStyle: labelStyle,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                style: inputStyle,
                validator: (value) => value == null || value.trim().isEmpty ? 'Enter full name' : null,
              ),
              const SizedBox(height: 20),

              // User Type
              TextFormField(
                controller: _userTypeController,
                decoration: InputDecoration(
                  labelText: 'User Type',
                  labelStyle: labelStyle,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                style: inputStyle,
                validator: (value) => value == null || value.trim().isEmpty ? 'Enter user type' : null,
              ),
              const SizedBox(height: 20),

              // Profile Image URL
              TextFormField(
                controller: _profileImageController,
                decoration: InputDecoration(
                  labelText: 'Profile Image URL (optional)',
                  labelStyle: labelStyle,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                style: inputStyle,
              ),
              const SizedBox(height: 30),

              // Submit Button
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton.icon(
                      onPressed: updateProfile,
                      icon: Icon(Icons.save),
                      label: Text('Update Profile', style: GoogleFonts.poppins()),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),

              const SizedBox(height: 20),

              if (_responseMessage.isNotEmpty)
                Text(
                  _responseMessage,
                  style: GoogleFonts.poppins(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
