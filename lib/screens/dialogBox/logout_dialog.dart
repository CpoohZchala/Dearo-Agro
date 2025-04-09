import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

Future<void> logoutUser(BuildContext context) async {
  final String logoutUrl = "http://192.168.51.201:5000/api/users/logout";

  final response = await http.post(
    Uri.parse(logoutUrl),
    headers: {
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Logged out successfully")),
    );
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/signIn',
      (route) => false,
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Logout failed")),
    );
  }
}

// This dialog confirms logout and calls the above function
Future<void> showLogOutDialog(BuildContext context, String userId) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Confirm Logout',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: GoogleFonts.poppins(),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel', style: GoogleFonts.poppins(color: Colors.green)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Logout', style: GoogleFonts.poppins(color: Colors.red)),
            onPressed: () async {
              Navigator.of(context).pop(); // Close dialog
              await logoutUser(context); // Call backend logout
            },
          ),
        ],
      );
    },
  );
}
