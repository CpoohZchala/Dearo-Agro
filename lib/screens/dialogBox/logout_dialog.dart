import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> showLogOutDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title:  Text('Confirm Logout', style: GoogleFonts.poppins(fontWeight: FontWeight.bold),),
        content: const Text('Are you sure you want to logout?'),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel',style: GoogleFonts.poppins(color: Colors.green)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child:  Text('Logout',style: GoogleFonts.poppins(color: Colors.red)),
            onPressed: () async {
              
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/signIn',
                  (route) => false,
                );
              }
            },
          ),
        ],
      );
    },
  );
}