import 'package:flutter/material.dart';

class ResponsScreen extends StatefulWidget {
  const ResponsScreen({super.key});

  @override
  State<ResponsScreen> createState() => _ResponsScreenState();
}

class _ResponsScreenState extends State<ResponsScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:AppBar(
        title:const Text("Responses Screen")
      )
    );
  }
}