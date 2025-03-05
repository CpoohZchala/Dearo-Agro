import 'package:flutter/material.dart';

class CropDetailsScreen extends StatefulWidget {
  const CropDetailsScreen({super.key});

  @override
  State<CropDetailsScreen> createState() => _CropDetailsScreenState();
}

class _CropDetailsScreenState extends State<CropDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Crop Details Screen"),
      ),
    );
  }
}
