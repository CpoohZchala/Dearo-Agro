import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          double maxWidth = constraints.maxWidth;
          double padding = maxWidth > 600 ? 50.0 : 16.0; // Adjust padding for larger screens

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: padding, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Image
                  Image.asset(
                    "assets/images/signup.png",
                    width: screenWidth * 0.5, // Adjusted width for responsiveness
                  ),
                  const SizedBox(height: 10),

                  // Title
                  Text(
                    "Sign-Up",
                    style: GoogleFonts.poppins(
                      fontSize: maxWidth > 600 ? 26 : 22, // Larger text for tablets
                      fontWeight: FontWeight.normal,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Sign-up Category TextField
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "Sign-up Category",
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Color(0xFF57A45B), width: 2),
                        ),
                      ),
                    ),
                  ),

                  // Full Name TextField
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "Full Name",
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Color(0xFF57A45B), width: 2),
                        ),
                      ),
                    ),
                  ),

                  // Mobile Number TextField
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "Mobile Number",
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Color(0xFF57A45B), width: 2),
                        ),
                      ),
                    ),
                  ),

                  // Password TextField
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Color(0xFF57A45B), width: 2),
                        ),
                      ),
                    ),
                  ),

                  // Confirm Password TextField
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Confirm Password",
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Color(0xFF57A45B), width: 2),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // SignUp Button
                  SizedBox(
                    width: maxWidth > 600 ? 400 : double.infinity, // Fixed width for tablets
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF57A45B),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, "/signIn");
                      },
                      child:  Text(
                        "Sign Up",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                 const  SizedBox(height:8),
                  Text("Do you Have an account ? SignIn",
                 style: GoogleFonts.poppins(
                  fontWeight: FontWeight.normal,


                 )),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
