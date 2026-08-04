import 'package:easy_localization/easy_localization.dart';
import 'package:farmeragriapp/api/auth_api.dart';
import 'package:farmeragriapp/models/user_model.dart';
import 'package:farmeragriapp/screens/dialogBox/success_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _isPasswordVisible = false;
  String? _selectedCategory;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
  TextEditingController();

  final List<String> _categories = [
    "Farmer",
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
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> signUp() async {
    final fullName = nameController.text.trim();
    final mobileNumber = mobileController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (_selectedCategory == null) {
      _showSnackBar("Please select whether you are a Farmer or Buyer.");
      return;
    }

    // Full Name validation
    if (fullName.isEmpty) {
      _showSnackBar("Please enter your full name.");
      return;
    }

    final namePattern = RegExp(r"^[a-zA-Z\s.'-]+$");

    if (!namePattern.hasMatch(fullName)) {
      _showSnackBar(
        "Full name can contain letters only. Numbers are not allowed.",
      );
      return;
    }

    final nameParts = fullName
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();

    if (nameParts.length < 2) {
      _showSnackBar("Please enter both your first name and last name.");
      return;
    }

    // Sri Lankan Mobile Number validation
    if (mobileNumber.isEmpty) {
      _showSnackBar("Please enter your mobile number.");
      return;
    }

    final mobilePattern = RegExp(r'^07\d{8}$');

    if (!mobilePattern.hasMatch(mobileNumber)) {
      _showSnackBar(
        "Please enter a valid mobile number. Example: 0771234567",
      );
      return;
    }

    if (password.isEmpty) {
      _showSnackBar("Please create a password.");
      return;
    }

    if (password.length < 6) {
      _showSnackBar("Password must be at least 6 characters long.");
      return;
    }

    if (confirmPassword.isEmpty) {
      _showSnackBar("Please confirm your password.");
      return;
    }

    if (password != confirmPassword) {
      _showSnackBar("Passwords do not match. Please check and try again.");
      return;
    }

    try {
      User newUser = User(
        fullName: fullName,
        mobileNumber: mobileNumber,
        password: password,
        userType: _selectedCategory,
      );

      final response = await AuthApi.signUp(newUser);

      if (response.statusCode == 200 || response.statusCode == 201) {
        showSuccessDialog(context);

        nameController.clear();
        mobileController.clear();
        passwordController.clear();
        confirmPasswordController.clear();

        setState(() {
          _selectedCategory = null;
        });
      } else if (response.statusCode == 409) {
        _showSnackBar(
          "This mobile number is already registered. Please sign in.",
        );
      } else if (response.statusCode >= 500) {
        _showSnackBar(
          "Server is busy right now. Please try again shortly.",
        );
      } else {
        _showSnackBar(
          "Signup failed. Please check your details and try again.",
        );
      }
    } catch (e) {
      _showSnackBar(
        "Something went wrong. Please check your internet connection.",
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    mobileController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
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
                  top: arcHeight + 12,
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
                              "assets/images/signup.png",
                              width: logoSize,
                              height: logoSize,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Sign Up",
                              style: GoogleFonts.poppins(
                                fontSize: headerFontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 24),

                            Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: DropdownButtonFormField<String>(
                                value: _selectedCategory,
                                decoration: InputDecoration(
                                  labelText: "Select Category",
                                  labelStyle: GoogleFonts.poppins(
                                    fontSize: 15,
                                    color: Colors.black,
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
                                items: _categories.map((String category) {
                                  return DropdownMenuItem<String>(
                                    value: category,
                                    child: Text(
                                      category,
                                      style: GoogleFonts.poppins(fontSize: 15),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedCategory = newValue;
                                  });
                                },
                              ),
                            ),

                            _buildTextField(
                              nameController,
                              "Full Name",
                              isDesktop,
                              isTablet,
                              textCapitalization: TextCapitalization.words,
                            ),

                            _buildTextField(
                              mobileController,
                              "Mobile Number",
                              isDesktop,
                              isTablet,
                              keyboardType: TextInputType.phone,
                              maxLength: 10,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                              ],
                            ),

                            _buildPasswordField(
                              passwordController,
                              "Password",
                              isDesktop,
                              isTablet,
                            ),

                            _buildPasswordField(
                              confirmPasswordController,
                              "Confirm Password",
                              isDesktop,
                              isTablet,
                            ),

                            const SizedBox(height: 24),

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                  const Color.fromARGB(255, 15, 59, 18),
                                  padding: EdgeInsets.symmetric(
                                    vertical: buttonPadding,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  elevation: 2,
                                ),
                                onPressed: signUp,
                                child: Text(
                                  "Sign Up",
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
                                text: "Already have an account? ",
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                ),
                                children: [
                                  TextSpan(
                                    text: "Sign In",
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.pushNamed(context, "/signIn");
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
      bool isTablet, {
        TextInputType keyboardType = TextInputType.text,
        List<TextInputFormatter>? inputFormatters,
        int? maxLength,
        TextCapitalization textCapitalization = TextCapitalization.none,
      }) {
    final fontSize = isDesktop
        ? 18.0
        : isTablet
        ? 16.0
        : 15.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        maxLength: maxLength,
        textCapitalization: textCapitalization,
        decoration: InputDecoration(
          counterText: "",
          labelText: label,
          labelStyle: GoogleFonts.poppins(
            fontSize: fontSize,
            color: Colors.black,
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
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(
            fontSize: fontSize,
            color: Colors.black,
          ),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
            icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
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