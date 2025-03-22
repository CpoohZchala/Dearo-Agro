import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

void main() => runApp(const InqueriesScreen());

class InquiriesApp extends StatelessWidget {
  const InquiriesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: InqueriesScreen());
  }
}

class InqueriesScreen extends StatefulWidget {
  const InqueriesScreen({super.key});

  @override
  State<InqueriesScreen> createState() => _InqueriesScreenState();
}

class _InqueriesScreenState extends State<InqueriesScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _screens = <Widget>[
    const FarmerHome(),
    const Text("Notifications",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    const Text("Crop Calendar",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    const Text("Account",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color.fromRGBO(87, 164, 91, 0.8),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(color: Colors.black26, blurRadius: 9, spreadRadius: 3),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: GNav(
          backgroundColor: Colors.transparent,
          color: Colors.white,
          activeColor: Colors.black,
          tabBackgroundColor: Colors.white.withOpacity(0.2),
          gap: 10,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          iconSize: 26,
          onTabChange: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          tabs: const [
            GButton(icon: Icons.home, text: "Home"),
            GButton(icon: Icons.notifications, text: "Alerts"),
            GButton(icon: Icons.calendar_month, text: "Calendar"),
            GButton(icon: Icons.account_circle, text: "Profile"),
          ],
        ),
      ),
    );
  }
}

class FarmerHome extends StatelessWidget {
  const FarmerHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ClipPath(
              clipper: ArcClipper(),
              child: Container(
                height: 190,
                color: const Color.fromRGBO(87, 164, 91, 0.8),
                child: Center(
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
                Positioned(
                  top: 40,
                  left: 10,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                  ),
                ),
                Positioned(
                  top: 40,
                  right: 20,
                  child: Image.asset(
                    "assets/icons/man.png",
                    width: 35,
                    height: 35,
                  ),
                ),
              ],
            ),
                    
                     
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(
              child: Text("Select inquiry type"),
            ),
            SizedBox(
              height: 235,
              child: GridView.count(
                primary: false,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                crossAxisCount: 3,
                children: <Widget>[
                  _buildGridButton(context, "Cultivational Details",
                      Icons.agriculture, "/cultivational"),
                  _buildGridButton(
                      context, "Crop Updates", Icons.man, "/crop_updates"),
                  _buildGridButton(context, "Cultivational Expenses",
                      Icons.attach_money, "/expenses"),
                  _buildGridButton(context, "Stock Details",
                      Icons.store_mall_directory, "/stock"),
                  _buildGridButton(
                      context, "Order Details", Icons.book, "/orders"),
                  _buildGridButton(
                      context, "Inquiries", Icons.forum, "/inqueries"),
                ],
              ),
            ),
            const SizedBox(height: 20),
           
           
          ],
        ),
      ),
    );
  }

  Widget _buildGridButton(
      BuildContext context, String title, IconData icon, String route) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[300],
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: () {
        Navigator.pushNamed(context, route);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 30),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.normal,
              fontSize: 12,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
