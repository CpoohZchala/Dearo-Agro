import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void showLogOutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [    
            Text(
              "Are you sure you want to log out? ",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 50),
            Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(87, 164, 91, 0.8),
                      foregroundColor: Colors.white),
                  onPressed: () {},
                  child: Text(
                    "Cancel",
                    style: GoogleFonts.poppins(),
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white),
                  onPressed: () {},
                  child: Text(
                    "Logout",
                    style: GoogleFonts.poppins(),
                  ),
                )
              ],
            ),
          ],
        ),
      );
    },
  );
}
