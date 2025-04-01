import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> showDeleteProfileDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirm Delete Account',
        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),),
        content:  Text('Are you sure you want to delete your account?',
         style: GoogleFonts.poppins()),
        actions: <Widget>[
          TextButton(
            child:  Text('No',
             style: GoogleFonts.poppins(color: Colors.green)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Yes', style: GoogleFonts.poppins(color: Colors.red)),
            onPressed: ()  {
            
            },
          ),
        ],
      );
    },
  );
}
