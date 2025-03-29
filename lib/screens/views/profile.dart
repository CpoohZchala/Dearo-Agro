import 'dart:convert';
import 'package:farmeragriapp/screens/dialogBox/deleteProfile_dialog.dart';
import 'package:farmeragriapp/screens/dialogBox/logout_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = "Loading...";
  String role = "Loading...";
  String profileImage = "";
  final String userId = "67e7780e0b7fee7cf5e87c6c";
  final String apiUrl = "http://192.168.8.125:5000/api/users";

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    final response = await http.get(Uri.parse("$apiUrl/$userId"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        userName = data['fullName'];
        role = data['userType'];
        profileImage = data['profileImage'] ?? "";
      });
    } else {
      print("Failed to load user profile");
    }
  }

  Future<void> updateProfile(
      String fullName, String userType, String profileImage) async {
    final response = await http.put(
      Uri.parse("$apiUrl/$userId"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        'fullName': fullName,
        'userType': userType,
        'profileImage': profileImage,
      }),
    );
    if (response.statusCode == 200) {
      fetchUserProfile(); // Reload the profile after update
    } else {
      print("Failed to update user profile");
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
                      Navigator.pushNamed(context, "/editprofile");
                    },
                  ),
                  const Divider(thickness: 1, color: Colors.grey),
                  _buildProfileOption(
                    icon: Icons.delete,
                    title: "Delete Profile",
                    onTap: () {
                      showDeleteProfileDialog(context);
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
                      showLogOutDialog(context);
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
      leading: Icon(icon, color: Color.fromRGBO(87, 164, 91, 0.8)),
      title: Text(
        title,
        style: GoogleFonts.poppins(fontSize: 15, color: Colors.black),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black),
      onTap: onTap,
    );
  }
}
