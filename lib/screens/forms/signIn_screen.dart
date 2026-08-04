import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:farmeragriapp/api/auth_api.dart';
import 'package:farmeragriapp/models/user_model.dart';
import 'package:farmeragriapp/screens/dialogBox/welcomBox.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

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
  bool _isSigningIn = false;
  String? _selectedUserType;

  final List<String> _userTypes = [
    "Farmer",
    "Marketing Officer",
    "Buyer",
  ];

  void _showSnackBar(String message, {bool isError = true}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: isError
            ? const Color.fromARGB(255, 180, 40, 40)
            : const Color.fromARGB(255, 45, 130, 60),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  String _cleanMobileNumber(String value) {
    return value.replaceAll(RegExp(r'[\s-]'), '');
  }

  bool _isValidSriLankanMobileNumber(String value) {
    final cleaned = _cleanMobileNumber(value);

    // Valid:
    // 0771234567
    // 94771234567
    // +94771234567
    return RegExp(r'^(?:0|94|\+94)7\d{8}$').hasMatch(cleaned);
  }

  String _getApiErrorMessage(int statusCode, String responseBody) {
    try {
      final decoded = jsonDecode(responseBody);

      if (decoded is Map<String, dynamic>) {
        final backendMessage =
            decoded['message'] ?? decoded['error'] ?? decoded['details'];

        if (backendMessage != null &&
            backendMessage.toString().trim().isNotEmpty) {
          return backendMessage.toString();
        }
      }
    } catch (_) {}

    if (statusCode == 400) {
      return 'Please check your mobile number, password, and user type.';
    }

    if (statusCode == 401) {
      return 'Incorrect mobile number or password.';
    }

    if (statusCode == 403) {
      return 'Your account does not have permission to sign in.';
    }

    if (statusCode == 404) {
      return 'Login service was not found. Please try again later.';
    }

    if (statusCode >= 500) {
      return 'Server is busy right now. Please try again shortly.';
    }

    return 'Sign in failed. Please check your details and try again.';
  }

  Future<void> signIn() async {
    if (_isSigningIn) return;

    final mobileNumber = _cleanMobileNumber(mobileController.text);
    final password = passwordController.text.trim();

    // TC_SI_002
    if (mobileNumber.isEmpty) {
      _showSnackBar("Please enter your mobile number.");
      return;
    }

    // TC_SI_003
    if (!_isValidSriLankanMobileNumber(mobileNumber)) {
      _showSnackBar(
        "Please enter a valid Sri Lankan mobile number. Example: 0771234567",
      );
      return;
    }

    // TC_SI_004
    if (password.isEmpty) {
      _showSnackBar("Please enter your password.");
      return;
    }

    // TC_SI_005
    if (password.length < 4) {
      _showSnackBar("Password must contain at least 4 characters.");
      return;
    }

    // TC_SI_006
    if (_selectedUserType == null) {
      _showSnackBar("Please select your user type.");
      return;
    }

    setState(() {
      _isSigningIn = true;
    });

    final user = User(
      mobileNumber: mobileNumber,
      password: password,
      userType: _selectedUserType!,
    );

    try {
      final response = await AuthApi.signIn(user).timeout(
        const Duration(seconds: 45),
      );

      debugPrint('========== LOGIN DEBUG ==========');
      debugPrint('Login status code: ${response.statusCode}');
      debugPrint('Login response body: ${response.body}');
      debugPrint('=================================');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is! Map<String, dynamic>) {
          _showSnackBar("Invalid login response from server.");
          return;
        }

        final String? token = data['token']?.toString();
        final String? userType =
            data['userType']?.toString() ?? _selectedUserType;

        if (token == null || token.isEmpty) {
          _showSnackBar(
            "Login failed because the server did not return a token.",
          );
          return;
        }

        if (JwtDecoder.isExpired(token)) {
          _showSnackBar(
            "Your login session has expired. Please sign in again.",
          );
          return;
        }

        final decodedToken = JwtDecoder.decode(token);

        final String? userId =
            decodedToken['id']?.toString() ??
                decodedToken['_id']?.toString() ??
                decodedToken['userId']?.toString();

        if (userId == null || userId.isEmpty) {
          _showSnackBar("Unable to verify your account. Please try again.");
          return;
        }

        await storage.write(key: "userId", value: userId);
        await storage.write(key: "authToken", value: token);
        await storage.write(key: "userType", value: userType);

        if (!mounted) return;

        _showSnackBar("Login successful. Welcome back!", isError: false);

        await Future.delayed(const Duration(milliseconds: 400));

        if (!mounted) return;

        // TC_SI_001
        if (userType == 'Farmer') {
          showWelcomeDialog(context, userId);

          // TC_SI_007
        } else if (userType == 'Marketing Officer') {
          Navigator.pushReplacementNamed(context, "/officerDashboard");

          // TC_SI_008
        } else if (userType == 'Buyer') {
          Navigator.pushReplacementNamed(context, "/buyerDashboard");
        } else {
          _showSnackBar(
            "This account type is not allowed to access the app.",
          );
        }
      } else {
        // TC_SI_009 and server errors
        _showSnackBar(
          _getApiErrorMessage(
            response.statusCode,
            response.body,
          ),
        );
      }
    } on TimeoutException {
      // TC_SI_010
      _showSnackBar(
        "The server is taking too long to respond. Please try again in a moment.",
      );
    } on SocketException {
      // TC_SI_010
      _showSnackBar(
        "No internet connection. Please check your mobile data or Wi-Fi.",
      );
    } on FormatException {
      _showSnackBar(
        "The server returned an invalid response. Please try again later.",
      );
    } catch (e) {
      debugPrint('Login exception: $e');

      _showSnackBar(
        "Unable to sign in right now. Please try again later.",
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSigningIn = false;
        });
      }
    }
  }

  @override
  void dispose() {
    mobileController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;
    final isDesktop = screenWidth >= 1024;

    final padding = isDesktop
        ? 120.0
        : isTablet
        ? 50.0
        : 16.0;

    final cardPadding = isDesktop
        ? 48.0
        : isTablet
        ? 32.0
        : 18.0;

    final headerFontSize = isDesktop
        ? 32.0
        : isTablet
        ? 26.0
        : 22.0;

    final arcHeight = isDesktop
        ? 220.0
        : isTablet
        ? 180.0
        : 150.0;

    final logoSize = isDesktop
        ? 180.0
        : isTablet
        ? 140.0
        : 100.0;

    final buttonFontSize = isDesktop
        ? 20.0
        : isTablet
        ? 18.0
        : 16.0;

    final buttonPadding = isDesktop
        ? 22.0
        : isTablet
        ? 18.0
        : 14.0;

    final cardWidth = isDesktop ? 500.0 : double.infinity;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background1.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: padding,
                  right: padding,
                  top: arcHeight - 30,
                  bottom: 24,
                ),
                child: SizedBox(
                  width: cardWidth,
                  child: Card(
                    color: Colors.transparent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        gradient: LinearGradient(
                          colors: [
                            const Color.fromARGB(255, 51, 162, 56)
                                .withOpacity(0.80),
                            const Color.fromARGB(2, 246, 247, 246)
                                .withOpacity(0.60),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: cardPadding,
                          vertical: cardPadding,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/SignIn.png",
                              width: logoSize,
                              height: logoSize,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Sign In',
                              style: GoogleFonts.poppins(
                                fontSize: headerFontSize,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 7, 7, 7),
                              ),
                            ),
                            const SizedBox(height: 24),

                            _buildTextField(
                              mobileController,
                              "Mobile Number",
                              isDesktop,
                              isTablet,
                            ),

                            _buildPasswordField(
                              passwordController,
                              "Password",
                              isDesktop,
                              isTablet,
                            ),

                            const SizedBox(height: 10),

                            DropdownButtonFormField<String>(
                              value: _selectedUserType,
                              decoration: InputDecoration(
                                labelText: "Select User Type",
                                labelStyle: GoogleFonts.poppins(
                                  fontSize: 15,
                                  color: const Color.fromARGB(204, 0, 0, 0),
                                ),
                                filled: true,
                                fillColor: Colors.grey[200],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(
                                    color: Color.fromRGBO(87, 164, 91, 0.8),
                                    width: 2,
                                  ),
                                ),
                              ),
                              items: _userTypes.map((String userType) {
                                return DropdownMenuItem<String>(
                                  value: userType,
                                  child: Text(
                                    userType,
                                    style: GoogleFonts.poppins(fontSize: 15),
                                  ),
                                );
                              }).toList(),
                              onChanged: _isSigningIn
                                  ? null
                                  : (String? newValue) {
                                setState(() {
                                  _selectedUserType = newValue;
                                });
                              },
                            ),

                            const SizedBox(height: 24),

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                  const Color.fromARGB(255, 5, 40, 6),
                                  padding: EdgeInsets.symmetric(
                                    vertical: buttonPadding,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  elevation: 2,
                                ),
                                onPressed: _isSigningIn ? null : signIn,
                                child: _isSigningIn
                                    ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.4,
                                    color: Colors.white,
                                  ),
                                )
                                    : Text(
                                  "Sign In",
                                  style: GoogleFonts.poppins(
                                    fontSize: buttonFontSize,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            RichText(
                              text: TextSpan(
                                text: "Don't have an account? ",
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                ),
                                children: [
                                  TextSpan(
                                    text: "Sign Up",
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        if (!_isSigningIn) {
                                          Navigator.pushNamed(
                                            context,
                                            "/signUp",
                                          );
                                        }
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label,
      bool isDesktop,
      bool isTablet,
      ) {
    final fontSize = isDesktop
        ? 18.0
        : isTablet
        ? 16.0
        : 15.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.phone,
        enabled: !_isSigningIn,
        maxLength: 15,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9+\-\s]')),
        ],
        decoration: InputDecoration(
          counterText: '',
          labelText: label,
          labelStyle: GoogleFonts.poppins(
            fontSize: fontSize,
            color: const Color.fromARGB(204, 0, 0, 0),
          ),
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Color.fromRGBO(87, 164, 91, 0.8),
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(
      TextEditingController controller,
      String label,
      bool isDesktop,
      bool isTablet,
      ) {
    final fontSize = isDesktop
        ? 18.0
        : isTablet
        ? 16.0
        : 15.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        obscureText: !_isPasswordVisible,
        enabled: !_isSigningIn,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(
            fontSize: fontSize,
            color: const Color.fromARGB(204, 0, 0, 0),
          ),
          suffixIcon: IconButton(
            onPressed: _isSigningIn
                ? null
                : () {
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
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
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