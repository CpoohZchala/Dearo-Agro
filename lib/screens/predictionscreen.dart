import 'package:flutter/material.dart';

class Predictionscreen extends StatefulWidget {
  const Predictionscreen({super.key});

  @override
  State<Predictionscreen> createState() => _PredictionscreenState();
}

class _PredictionscreenState extends State<Predictionscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title:const Text("Prediction Screen"),
      )
    );
  }
}