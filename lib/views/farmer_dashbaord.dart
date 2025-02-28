import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';


class FarmerDashboard extends StatefulWidget {
  const FarmerDashboard({super.key});

  @override
  State<FarmerDashboard> createState() => _FarmerDashboardState();
}

class _FarmerDashboardState extends State<FarmerDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
           
          
          ClipPath(
            clipper: WaveClipperTwo(),
            child: Container(
              height: 120,
              color: Color(0xFF57A45B),
              
            ),
          ),
          
          
        ],
      ),
    );
  }
  }

