import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:google_fonts/google_fonts.dart';

class CultivationalExpense extends StatefulWidget {
  const CultivationalExpense({super.key});

  @override
  State<CultivationalExpense> createState() => _CultivationalExpenseState();
}

class _CultivationalExpenseState extends State<CultivationalExpense> {
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
                height: 170,
                color: const Color.fromRGBO(87, 164, 91, 0.8),
                child: Row(
                  children: [
                    IconButton(
                      icon:
                          const Icon(Icons.arrow_back_ios, color: Colors.black),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(width: 270),
                    Image.asset(
                      "assets/icons/dollar.png",
                      height: 35,
                      width: 35,
                    )
                  ],
                ),
              ),
            ),
             Opacity(
              opacity: 1.0,
              child: Image.asset("assets/images/image4.png",
                  height: 200, width: 200),
            ),
            
            Card(
              color: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(
                    color: const Color.fromRGBO(87, 164, 91, 0.8), width: 2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Align text to left
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          " 2023/04/01",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10), // Add spacing
                    Text(
                      "Land Preparation  is Done.",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10), // Add spacing
                    Text(
                      "Rs.20000",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, "/addCultivational");
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Color.fromRGBO(87, 164, 91, 0.8),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 15),
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, "/addCultivational");
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Color.fromRGBO(87, 164, 91, 0.8),
                            size: 20,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              color: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(
                    color: const Color.fromRGBO(87, 164, 91, 0.8), width: 2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Align text to left
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          " 2023/04/20",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10), // Add spacing
                    Text(
                      "Land Preparation  is Done.",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10), // Add spacing
                    Text(
                      "Rs.10000",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Color.fromRGBO(87, 164, 91, 0.8),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 15),
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, "/addCultivational");
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Color.fromRGBO(87, 164, 91, 0.8),
                            size: 20,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/addCultivational");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(87, 164, 91, 0.8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "+ Add Expense",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
           
          ],
        ),
      ),
    );
  }
}