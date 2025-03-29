import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void showWelcomeDialog(BuildContext context) {
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
            Align(
              alignment: Alignment.topCenter,
              child:  Text(
              "Welcome To Farmer Dashboard !",
               textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
              
            ),
           
            const SizedBox(height: 10),
           
          ],
        ),
      );
    },
  );

  // Auto navigate to FarmerMain Dashboard after 2 seconds
  Future.delayed(const Duration(seconds: 2), () {
    Navigator.pushReplacementNamed(context, "/fdashboard");
  });
}
