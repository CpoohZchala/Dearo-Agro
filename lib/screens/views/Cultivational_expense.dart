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
      body: Stack(
        children: [
          // Fixed ArcClipper
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipPath(
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
                    const Spacer(),
                    Image.asset(
                      "assets/icons/leaf.png",
                      height: 35,
                      width: 35,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Scrollable Cards List
          Padding(
            padding:
                const EdgeInsets.only(top: 180), // Avoid overlapping ArcClipper
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                  bottom: 70), // To avoid overlap with button
              child: Column(
                children: <Widget>[
                  _buildCard("2023/04/01", "Land Preparation is Done.", 12000),
                  const SizedBox(height: 10),
                  _buildCard("2023/04/20", "Fertilization is Done.", 15000),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),

          // Fixed Button
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/addExpenses");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(87, 164, 91, 0.8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "+ Add Expenses",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(String date, String description, double expense) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side:
            const BorderSide(color: Color.fromRGBO(87, 164, 91, 0.8), width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.normal,
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Rs. $expense",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.green[700],
              ),
            ),
            const SizedBox(height: 10),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.delete,
                    color: Color.fromRGBO(87, 164, 91, 0.8),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 15),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/addExpenses");
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
    );
  }
}
