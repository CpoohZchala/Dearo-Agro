import 'package:farmeragriapp/screens/views/cropCalender.dart';
import 'package:farmeragriapp/screens/views/notifications.dart';
import 'package:farmeragriapp/screens/views/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart'
    as custom_clippers;
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
      home: Placeholder(),
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
      FarmerHome(),
      const SoilTestScreen(),
      const CropCalenderScreen(),
      ProfileScreen(
        userId: widget.userId,
        userType: "Farmer",
      ),
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
            GButton(icon: Icons.notifications, text: "Test"),
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;
    final isDesktop = screenWidth >= 1024;
    final arcHeight = isDesktop
        ? 260.0
        : isTablet
            ? 210.0
            : 190.0;
    final gridCrossAxisCount = isDesktop
        ? 4
        : isTablet
            ? 3
            : 2;
    final gridChildAspectRatio = isDesktop
        ? 1.2
        : isTablet
            ? 1
            : 0.9;
    final gridHeight = isDesktop
        ? 320.0
        : isTablet
            ? 270.0
            : 235.0;
    final gridFontSize = isDesktop
        ? 16.0
        : isTablet
            ? 14.0
            : 12.0;
    final cardImageSize = isDesktop
        ? 160.0
        : isTablet
            ? 140.0
            : 110.0;
    final cardFontSize = isDesktop
        ? 18.0
        : isTablet
            ? 17.0
            : 15.0;
    final cardPadding = isDesktop
        ? 28.0
        : isTablet
            ? 20.0
            : 15.0;
    final cardMargin = isDesktop
        ? 28.0
        : isTablet
            ? 20.0
            : 15.0;

    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = "Good Morning";
    } else if (hour < 18) {
      greeting = "Good Afternoon";
    } else {
      greeting = "Good Night";
    }

    final String userName = " User";

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: <Widget>[
                ClipPath(
                  clipper: custom_clippers.ArcClipper(),
                  child: Container(
                    height: arcHeight,
                    color: const Color.fromRGBO(87, 164, 91, 0.8),
                    child: Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 25),
                          Text(
                            "Hi $userName,",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: isDesktop
                                  ? 22
                                  : isTablet
                                      ? 18
                                      : 16,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            greeting,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.normal,
                              fontSize: isDesktop
                                  ? 20
                                  : isTablet
                                      ? 16
                                      : 14,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: gridHeight,
                  child: GridView.count(
                    primary: false,
                    padding: const EdgeInsets.all(20),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    crossAxisCount: gridCrossAxisCount,
                    childAspectRatio: gridChildAspectRatio.toDouble(),
                    children: <Widget>[
                      _buildGridButton(context, "Cultivational Details",
                          Icons.agriculture, "/cultivational", gridFontSize),
                      _buildGridButton(context, "Crop Updates", Icons.man,
                          "/crop_updates", gridFontSize),
                      _buildGridButton(context, "Cultivational Expenses",
                          Icons.attach_money, "/expenses", gridFontSize),
                      _buildGridButton(context, "Stock Details",
                          Icons.store_mall_directory, "/stock", gridFontSize),
                      _buildGridButton(context, "Order Details", Icons.book,
                          "/orders", gridFontSize),
                      _buildGridButton(context, "Inquiries", Icons.forum,
                          "/technical", gridFontSize),
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
                          fontSize: cardFontSize,
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
                  margin: EdgeInsets.all(cardMargin),
                  child: Padding(
                    padding: EdgeInsets.all(cardPadding),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: GoogleFonts.poppins(
                                    fontSize: cardFontSize,
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
                              height: cardImageSize,
                              width: cardImageSize,
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, "/prediction");
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[400],
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                  vertical: isDesktop
                                      ? 18
                                      : isTablet
                                          ? 14
                                          : 10),
                              textStyle: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: cardFontSize,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Continue'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildGridButton(BuildContext context, String title, IconData icon,
      String route, double fontSize) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[300],
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 1,
      ),
      onPressed: () {
        Navigator.pushNamed(context, route);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: fontSize + 14),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.normal,
              fontSize: fontSize,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
