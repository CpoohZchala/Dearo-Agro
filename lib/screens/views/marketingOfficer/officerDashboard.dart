import 'package:farmeragriapp/screens/views/marketingOfficer/manageFarmersScreen.dart';
import 'package:farmeragriapp/screens/views/marketingOfficer/officerHome.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class OfficerDashboard extends StatefulWidget {
  final dynamic userId;

  const OfficerDashboard({super.key, required this.userId});

  @override
  State<OfficerDashboard> createState() => _OfficerDashboardState();
}

class _OfficerDashboardState extends State<OfficerDashboard> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      const OfficerHome(),
      const ManageFarmersScreen(),
    ];
     

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color.fromRGBO(19, 73, 2, 0.8),
          borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
          boxShadow: [
            BoxShadow(
                color: Color.fromARGB(66, 118, 117, 117),
                blurRadius: 9,
                spreadRadius: 3),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: GNav(
          backgroundColor: Colors.transparent,
          color: Colors.yellow,
          activeColor: Colors.white,
          tabBackgroundColor: Colors.white24,
          gap: 10,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          iconSize: 30,
          onTabChange: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          tabs: const [
            GButton(icon: Icons.home, text: "Home"),
            GButton(icon: Icons.group, text: "Manage Farmers"),
          ],
        ),
      ),
    );
  }
}
