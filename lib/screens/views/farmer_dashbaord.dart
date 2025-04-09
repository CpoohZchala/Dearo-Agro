import 'package:farmeragriapp/screens/views/cropCalender.dart';
import 'package:farmeragriapp/screens/views/notifications.dart';
import 'package:farmeragriapp/screens/views/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

void main() {
  runApp(const FarmerDashboardApp());
}

class FarmerDashboardApp extends StatelessWidget {
  const FarmerDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Placeholder(), // Placeholder to be replaced by navigation after login
    );
  }
}

class FarmerDashboard extends StatefulWidget {
  final String userId;

  const FarmerDashboard({super.key, required this.userId});

  @override
  State<FarmerDashboard> createState() => _FarmerDashboardState();
}

class _FarmerDashboardState extends State<FarmerDashboard> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      const FarmerHome(),
      const NotificationScreen(),
      const CropCalenderScreen(),
      ProfileScreen(userId: widget.userId),
    ];

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
                      const SizedBox(height: 25),
                      Text(
                        "Hi Chalani Jayakodi,",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        "Good Afternoon!",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
            Column(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    "Crop Care",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
            Card(
              color: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: const BorderSide(
                  color: Color.fromRGBO(87, 164, 91, 0.8),
                  width: 2,
                ),
              ),
              margin: const EdgeInsets.all(15),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                color: Colors.black,
                              ),
                              children: const [
                                TextSpan(text: "Diagnose and treat\n"),
                                TextSpan(text: "your crop's pest and\n"),
                                TextSpan(text: "disease"),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Image.asset(
                          "assets/images/image1.png",
                          height: 130,
                          width: 130,
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/prediction");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[400],
                        foregroundColor: Colors.black,
                      ),
                      child: Text(
                        'Continue',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
