import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class CultivationalExpense extends StatefulWidget {
  const CultivationalExpense({super.key});

  @override
  State<CultivationalExpense> createState() => _CultivationalExpenseState();
}

class _CultivationalExpenseState extends State<CultivationalExpense> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
       backgroundColor: Colors.white,
       body: SingleChildScrollView(
        child: Column(
          children:<Widget>[
            ClipPath(
              clipper:ArcClipper(),
              child:Container(
                height:150,
                color: const Color.fromRGBO(87, 164, 91, 0.8),
              )
            ),
            const SizedBox(
              height:10
              ),

             
          ]

        )
        
       )
    );
  }
}