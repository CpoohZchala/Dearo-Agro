import 'package:farmeragriapp/screens/dialogBox/welcomBox.dart';
import 'package:farmeragriapp/screens/views/farmer_dashbaord.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _isPasswordVisible = false;
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final storage = const FlutterSecureStorage();

  Future<void> signIn() async {
  if (mobileController.text.isEmpty || passwordController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please fill all fields")),
    );
    return;
  }

  var url = Uri.parse('http://192.168.51.201:5000/api/auth/signin');
  var response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: json.encode({
      'mobileNumber': mobileController.text,
      'password': passwordController.text,
    }),
  );

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    String? token = data['token'];
    String? userType = data['userType'];

    if (token != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      String? userId = decodedToken['id'];

      if (userId != null) {
        await storage.write(key: "userId", value: userId);
        print("User ID saved from token: $userId");

        if (userType == 'Farmer') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => FarmerDashboard(userId: userId),
            ),
          );
        } else if (userType == 'Marketing Officer') {
          Navigator.pushNamed(context, "/marketingOfficerDashboard");
        } else if (userType == 'Super Admin') {
          Navigator.pushNamed(context, "/adminDashboard");
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Invalid role: $userType")),
          );
        }
      } else {
        print("User ID not found in token");
      }
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error signing in: ${response.body}")),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;

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
          double maxWidth = constraints.maxWidth;
          double padding = maxWidth > 600 ? 50.0 : 16.0;

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: padding, vertical: 16.0),
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
                      fontSize: maxWidth > 600 ? 26 : 22,
                      fontWeight: FontWeight.normal,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(mobileController, "Mobile Number"),
                  _buildPasswordField(passwordController, "Password"),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: maxWidth > 600 ? 400 : double.infinity,
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
                              color: const Color.fromRGBO(87, 164, 91, 0.8)),
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
            borderSide:
                const BorderSide(color: Color.fromRGBO(87, 164, 91, 0.8), width: 2),
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
                color: Colors.grey),
          ),
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: Color.fromRGBO(87, 164, 91, 0.8), width: 2),
          ),
        ),
      ),
    );
  }
}
