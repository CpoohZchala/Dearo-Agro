import 'package:farmeragriapp/screens/views/farmer/cropCalender.dart';
import 'package:farmeragriapp/screens/views/farmer/notifications.dart';
import 'package:farmeragriapp/screens/views/farmer/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart'
as custom_clippers;
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../../agri_chatbot_screen.dart';

class FarmerDashboard extends StatefulWidget {
  final String userId;

  const FarmerDashboard({
    super.key,
    required this.userId,
  });

  @override
  State<FarmerDashboard> createState() => _FarmerDashboardState();
}

class _FarmerDashboardState extends State<FarmerDashboard> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const FarmerHome(),
      const SoilTestScreen(),
      const CropCalenderScreen(),
      ProfileScreen(
        userId: widget.userId,
        userType: "Farmer",
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color.fromRGBO(1, 45, 9, 0.8),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(66, 6, 131, 1),
              blurRadius: 9,
              spreadRadius: 3,
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        child: GNav(
          selectedIndex: _selectedIndex,
          backgroundColor: Colors.transparent,
          color: Colors.yellow,
          activeColor: Colors.white,
          tabBackgroundColor: const Color(0x33FFFFFF),
          gap: 4,
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 11,
          ),
          iconSize: 30,
          onTabChange: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          tabs: const [
            GButton(
              icon: Icons.home,
              text: "Home",
            ),
            GButton(
              icon: Icons.notifications,
              text: "Test",
            ),
            GButton(
              icon: Icons.calendar_month,
              text: "Calendar",
            ),
            GButton(
              icon: Icons.account_circle,
              text: "Profile",
            ),
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
    const double arcHeight = 250.0;
    const int gridCrossAxisCount = 3;
    const double gridChildAspectRatio = 0.66;
    const double gridHeight = 190.0;
    const double gridFontSize = 12.0;

    final hour = DateTime.now().hour;
    String greeting;

    if (hour < 12) {
      greeting = "Good Morning";
    } else if (hour < 18) {
      greeting = "Good Afternoon";
    } else {
      greeting = "Good Night";
    }

    const String userName = "User";

    return SizedBox.expand(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/images/background.jpg",
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                ClipPath(
                  clipper: custom_clippers.ArcClipper(),
                  child: Container(
                    height: arcHeight,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(40, 159, 46, 1),
                          Color.fromRGBO(87, 164, 91, 0.7),
                          Color.fromARGB(255, 31, 150, 31),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 35),
                          Text(
                            "Hi $userName,",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            greeting,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                SizedBox(
                  height: gridHeight,
                  child: GridView.count(
                    primary: false,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: gridCrossAxisCount,
                    childAspectRatio: gridChildAspectRatio,
                    children: [
                      _modernGridButton(
                        context,
                        'Cultivational Details',
                        Icons.agriculture,
                            () {
                          Navigator.pushNamed(context, "/cultivational");
                        },
                        gridFontSize,
                      ),
                      _modernGridButton(
                        context,
                        'Crop Updates',
                        Icons.eco,
                            () {
                          Navigator.pushNamed(context, "/crop_updates");
                        },
                        gridFontSize,
                      ),
                      _modernGridButton(
                        context,
                        'Cultivational Expenses',
                        Icons.attach_money,
                            () {
                          Navigator.pushNamed(context, "/expenses");
                        },
                        gridFontSize,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _agriChatbotBanner(context),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _modernGridButton(
      BuildContext context,
      String title,
      IconData icon,
      VoidCallback onTap,
      double fontSize,
      ) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
            colors: [
              Color.fromRGBO(82, 99, 82, 0.125),
              Color.fromRGBO(117, 156, 119, 0.086),
              Color.fromRGBO(255, 255, 255, 0.28),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x261A301A),
              blurRadius: 8,
              offset: Offset(2, 4),
            ),
          ],
          border: Border.all(
            color: Colors.white,
            width: 1.2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Color(0xB3000000),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: fontSize + 18,
                color: const Color.fromARGB(255, 238, 246, 1),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: fontSize + 2,
                color: Colors.white,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _agriChatbotBanner(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AgriChatbotScreen(),
            ),
          );
        },
        child: Ink(
          height: 112,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              colors: [
                Color(0xFF195C2A),
                Color(0xFF4DAA58),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x66388B43),
                blurRadius: 16,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              children: [
                Positioned(
                  top: -38,
                  right: -24,
                  child: Container(
                    width: 145,
                    height: 145,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0x1FFFFFFF),
                    ),
                  ),
                ),
                Positioned(
                  right: 30,
                  bottom: -45,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0x1A000000),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 17,
                    vertical: 15,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0x2EFFFFFF),
                          border: Border.all(
                            color: const Color(0x59FFFFFF),
                          ),
                        ),
                        child: const Icon(
                          Icons.auto_awesome_rounded,
                          color: Colors.white,
                          size: 29,
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ask Agri AI',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Get instant help for your crops',
                              style: TextStyle(
                                color: Color(0xDFFFFFFF),
                                fontSize: 12.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 7),
                            Text(
                              'Sinhala & English support',
                              style: TextStyle(
                                color: Color(0xBFFFFFFF),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 43,
                        height: 43,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0x33FFFFFF),
                        ),
                        child: const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 23,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}