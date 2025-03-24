import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Example user data
  final String userName = "Chalani Jayakodi";
  final String role = "Farmer";

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
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey,
                  child: Icon(
                    Icons.account_circle,
                    size: 80,
                    color: Colors.white,
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
                      // Handle Edit Profile action
                    },
                  ),
                  const Divider(thickness: 1, color: Colors.grey),
                  _buildProfileOption(
                    icon: Icons.delete,
                    title: "Delete Profile",
                    onTap: () {
                      // Handle Delete Profile action
                    },
                  ),
                  const Divider(thickness: 1, color: Colors.grey),
                  _buildProfileOption(
                    icon: Icons.lock,
                    title: "Change Password",
                    onTap: () {
                      // Handle Change Password action
                    },
                  ),
                  const Divider(thickness: 1, color: Colors.grey),
                  _buildProfileOption(
                    icon: Icons.logout,
                    title: "Logout",
                    onTap: () {
                      // Handle Logout action
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
      leading: Icon(icon, color: Color.fromRGBO(87, 164, 91, 0.8),),
      title: Text(
        title,
        style: GoogleFonts.poppins(fontSize: 15, color: Colors.black),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black),
      onTap: onTap,
    );
  }
}
