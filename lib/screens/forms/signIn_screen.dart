import 'dart:convert';
import 'package:farmeragriapp/api/auth_api.dart';
import 'package:farmeragriapp/models/user_model.dart';
import 'package:farmeragriapp/screens/dialogBox/welcomBox.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter/gestures.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final storage = const FlutterSecureStorage();
  bool _isPasswordVisible = false;

  Future<void> signIn() async {
    if (mobileController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    User user = User(
      mobileNumber: mobileController.text,
      password: passwordController.text,
    );

    try {
      final response = await AuthApi.signIn(user);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String? token = data['token'];
        final String? userType = data['userType'];

        if (token != null) {
          final decodedToken = JwtDecoder.decode(token);
          final String? userId = decodedToken['id'];

          if (userId != null) {
            await storage.write(key: "userId", value: userId);
            print("User ID saved: $userId");

            if (userType == 'Farmer') {
              showWelcomeDialog(context, userId);
            } else if (userType == 'Marketing Officer') {
              Navigator.pushNamed(context, "/marketingOfficerDashboard");
            } else if (userType == 'Super Admin') {
              Navigator.pushNamed(context, "/adminDashboard");
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Unknown user role: $userType")),
              );
            }
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Sign-in failed: ${response.body}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 600;
          final padding = isWide ? 50.0 : 16.0;

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: padding, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/SignIn.png",
                    width: screenWidth * 0.5,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Sign-In",
                    style: GoogleFonts.poppins(
                      fontSize: isWide ? 26 : 22,
                      fontWeight: FontWeight.normal,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(mobileController, "Mobile Number"),
                  _buildPasswordField(passwordController, "Password"),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: isWide ? 400 : double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(87, 164, 91, 0.8),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: signIn,
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
                  const SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      text: "Don't have an account? ",
                      style: GoogleFonts.poppins(color: Colors.black),
                      children: [
                        TextSpan(
                          text: "Sign-Up",
                          style: GoogleFonts.poppins(
                            color: const Color.fromRGBO(87, 164, 91, 0.8),
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushNamed(context, "/signUp");
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          labelText: label,
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
              color: Color.fromRGBO(87, 164, 91, 0.8),
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        obscureText: !_isPasswordVisible,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(fontSize: 15),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
            icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey,
            ),
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
              color: Color.fromRGBO(87, 164, 91, 0.8),
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}
