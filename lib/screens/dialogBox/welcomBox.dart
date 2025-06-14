import 'package:farmeragriapp/screens/views/farmer_dashbaord.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void showWelcomeDialog(BuildContext context, String userId) {
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

  Future.delayed(const Duration(seconds: 2), () {
     Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => FarmerDashboard(userId: userId),
            ),
          );
  });
}
