import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class CultivationalAddScreen extends StatefulWidget {
  const CultivationalAddScreen({super.key});

  @override
  State<CultivationalAddScreen> createState() => _CultivationalAddScreenState();
}

class _CultivationalAddScreenState extends State<CultivationalAddScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipPath(
              clipper: ArcClipper(),
              child: Container(
                  height: 190,
                  color: const Color.fromRGBO(87, 164, 91, 0.8),
                  child: Center(
                      child: Row(children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back_ios),),
                       const SizedBox(width:270),
                       Image.asset("assets/icons/man.png",
                       width: 35,height: 35,),
                       ],
                  
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
