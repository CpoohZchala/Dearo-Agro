import 'dart:convert';
import 'package:farmeragriapp/screens/dialogBox/deleteProfile_dialog.dart';
import 'package:farmeragriapp/screens/dialogBox/logout_dialog.dart';
import 'package:farmeragriapp/screens/forms/editProfile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  final String userId;
  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = "Loading...";
  String role = "Loading...";
  String profileImage = "";
  final String apiUrl = "http://192.168.51.201:5000/api/users";

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

//show user profile
  Future<void> fetchUserProfile() async {
    final response = await http.get(Uri.parse("$apiUrl/${widget.userId}"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        userName = data['fullName'];
        role = data['userType'];
        profileImage = data['profileImage'] ?? "";
      });
    } else {
      print("Failed to load user profile. Code: ${response.statusCode}");
    }
  }

//Update user Profile
  Future<void> updateProfile(
      String fullName, String userType, String profileImage) async {
    final response = await http.put(
      Uri.parse("$apiUrl/${widget.userId}"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        'fullName': fullName,
        'userType': userType,
        'profileImage': profileImage,
      }),
    );
    if (response.statusCode == 200) {
      fetchUserProfile();
    } else {
      print("Failed to update user profile");
    }
  }

//Delete user profile
  Future<void> deleteUserProfile() async {
    final response = await http.delete(
      Uri.parse("$apiUrl/${widget.userId}"),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Profile deleted successfully")),
      );
      Navigator.pushReplacementNamed(context, "/signIn");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete profile")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                ClipPath(
                  clipper: ArcClipper(),
                  child: Container(
                    height: 190,
                    color: const Color.fromRGBO(87, 164, 91, 0.8),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey,
                    backgroundImage: profileImage.isNotEmpty
                        ? NetworkImage(profileImage)
                        : null,
                    child: profileImage.isEmpty
                        ? const Icon(Icons.account_circle,
                            size: 80, color: Colors.white)
                        : null,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  userName,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  role,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.yellow[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildProfileOption(
                    icon: Icons.edit,
                    title: "Edit Profile",
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              UpdateProfileScreen(userId: widget.userId),
                        ),
                      );
                    },
                  ),
                  const Divider(thickness: 1, color: Colors.grey),
                  _buildProfileOption(
                    icon: Icons.delete,
                    title: "Delete Profile",
                    onTap: () {
                      showDeleteProfileDialog(context, widget.userId);
                    },
                  ),
                  const Divider(thickness: 1, color: Colors.grey),
                  _buildProfileOption(
                    icon: Icons.lock,
                    title: "Change Password",
                    onTap: () {
                      Navigator.pushNamed(context, "/changedPassword");
                    },
                  ),
                  const Divider(thickness: 1, color: Colors.grey),
                  _buildProfileOption(
                    icon: Icons.logout,
                    title: "Logout",
                    onTap: () {
                      showLogOutDialog(context, widget.userId);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color.fromRGBO(87, 164, 91, 0.8)),
      title: Text(
        title,
        style: GoogleFonts.poppins(fontSize: 15, color: Colors.black),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black),
      onTap: onTap,
    );
  }
}
