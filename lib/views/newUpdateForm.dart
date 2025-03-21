import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class NewUpdateForm extends StatefulWidget {
  const NewUpdateForm({super.key});

  @override
  State<NewUpdateForm> createState() => _NewUpdateFormState();
}

class _NewUpdateFormState extends State<NewUpdateForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: ArcClipper(),
              child: Container(
                height: 190,
                color: const Color.fromRGBO(87, 164, 91, 0.8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios),
                    ),
                    const Spacer(),
                    Image.asset(
                      "assets/icons/leaf.png",
                      height: 35,
                      width: 35,
                    )
                  ],
                ),
              ),
            ),
          ),

          // Scrollable Cards List
          const Padding(
              padding: EdgeInsets.only(top: 180), //To avoid Overlapping with ArcClip
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 70),  //To avoid overlap with button
                child:Column(children:<Widget>[
                   
                ])
              ))
        ],
      ),
    );
  }
}
