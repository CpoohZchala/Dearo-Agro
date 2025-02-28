import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignInScreen> {
  bool _isPasswordVisible = false;

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
          double padding =
              maxWidth > 600 ? 50.0 : 16.0; // Adjust padding for larger screens

          return SingleChildScrollView(
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: padding, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Image
                  Image.asset(
                    "assets/images/SignIn.png",
                    width:
                        screenWidth * 0.5, // Adjusted width for responsiveness
                  ),
                  const SizedBox(height: 10),

                  // Title
                  Text(
                    "Sign-In",
                    style: GoogleFonts.poppins(
                      fontSize:
                          maxWidth > 600 ? 26 : 22, // Larger text for tablets
                      fontWeight: FontWeight.normal,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Mobile Number TextField
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "Mobile Number",
                        labelStyle: GoogleFonts.poppins(fontSize: 15),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Color(0xFF57A45B), width: 2),
                        ),
                      ),
                    ),
                  ),

                  // Password TextField
                  // Password TextField
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: TextField(
                      obscureText:
                          !_isPasswordVisible, // Toggle visibility here
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: GoogleFonts.poppins(fontSize: 15),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible =
                                  !_isPasswordVisible; // Toggle state
                            });
                          },
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Color(0xFF57A45B), width: 2),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // SignUp Button
                  SizedBox(
                    width: maxWidth > 600
                        ? 400
                        : double.infinity, // Fixed width for tablets
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF57A45B),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, "/fdashboard");
                      },
                      child: Text(
                        "Sign In",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  RichText(
                    text: TextSpan(
                      text: "Do you haven't an account? ",
                      style: GoogleFonts.poppins(color: Colors.black),
                      children: [
                        TextSpan(
                          text: "Sign-Up",
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF57A45B),
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushNamed(context, "/signUp");
                            },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
