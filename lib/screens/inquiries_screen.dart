import 'package:flutter/material.dart';

class InqueriesScreen extends StatefulWidget {
  const InqueriesScreen({super.key});

  @override
  State<InqueriesScreen> createState() => _InquerState();
}

class _InquerState extends State<InqueriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title:const Text("Inqueries Screen"),
      )
    );
  }
}