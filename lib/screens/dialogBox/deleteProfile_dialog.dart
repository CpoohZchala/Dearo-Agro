import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

Future<void> showDeleteProfileDialog(BuildContext context, String userId) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Confirm Delete Account',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to delete your account?',
          style: GoogleFonts.poppins(),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('No', style: GoogleFonts.poppins(color: Colors.green)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Yes', style: GoogleFonts.poppins(color: Colors.red)),
            onPressed: () async {
              Navigator.of(context).pop(); // Close the dialog first
              await deleteUserProfile(context, userId); // Then delete
            },
          ),
        ],
      );
    },
  );
}

Future<void> deleteUserProfile(BuildContext context, String userId) async {
  final String apiUrl = "http://192.168.8.125:5000/api/users";

  final response = await http.delete(Uri.parse("$apiUrl/$userId"));

  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Profile deleted successfully")),
    );
    Navigator.pushReplacementNamed(context, "/signIn");
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Failed to delete profile")),
    );
  }
}
