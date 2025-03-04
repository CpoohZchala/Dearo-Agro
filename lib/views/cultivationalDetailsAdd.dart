import 'package:flutter/material.dart';

class CultivationalAddScreen extends StatefulWidget {
  const CultivationalAddScreen({super.key});

  @override
  State<CultivationalAddScreen> createState() => _CultivationalAddScreenState();
}

class _CultivationalAddScreenState extends State<CultivationalAddScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:AppBar(
        title:const Text("Add Cultivational Detalils"),
        backgroundColor: Colors.green,
      )
    );
  }
}