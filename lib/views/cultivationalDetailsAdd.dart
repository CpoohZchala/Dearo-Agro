import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:google_fonts/google_fonts.dart';

class CultivationalAddScreen extends StatefulWidget {
  const CultivationalAddScreen({super.key});

  @override
  State<CultivationalAddScreen> createState() => _CultivationalAddScreenState();
}

class _CultivationalAddScreenState extends State<CultivationalAddScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipPath(
              clipper: ArcClipper(),
              child: Container(
                height: 190,
                color: const Color.fromRGBO(87, 164, 91, 0.8),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back_ios),
                      ),
                      Image.asset(
                        "assets/icons/man.png",
                        width: 35,
                        height: 35,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),

            _buildTextField("Type Your Member ID "),
            _buildTextField("Select Your Crop Category"),
            _buildTextField("Select Your Crop"),
            _buildTextField("Location Address Type here"),
            _buildTextField("Start Date "),
            _buildTextField("Select Your Destrict"),
            _buildTextField("Select Your City")
          ],
        ),
      ),
    );
  }

  // **Reusable Text Field**
  Widget _buildTextField(String label) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(fontSize: 15),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              
                color: Color.fromRGBO(19, 146, 25, 0.8), width: 3),
          ),
        ),
      ),
    );
  }
}
