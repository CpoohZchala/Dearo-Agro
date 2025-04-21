import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void showSuccessDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Colors.amber,
              size: 50,
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                "User registration successful!",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(87, 164, 91, 0.8),
                  foregroundColor: Colors.white),
              onPressed: () {
                Navigator.pushNamed(context, "/signIn");
              },
              child: Text(
                "Sign In",
                style: GoogleFonts.poppins(),
              ),
            )
          ],
        ),
      );
    },
  );
}
