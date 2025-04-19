import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

class TechnicalIScreen extends StatefulWidget {
  const TechnicalIScreen({super.key});

  @override
  State<TechnicalIScreen> createState() => _TechnicalIScreenState();
}

class _TechnicalIScreenState extends State<TechnicalIScreen> {
  // ignore: unused_field
  DateTime? _selectedDate;
  // ignore: unused_field
  File? _selectedImage;
  // ignore: unused_field
  File? _selectedDocument;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _documentController = TextEditingController();


  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text =
            "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _imageController.text = path.basename(pickedFile.path);
      });
    }
  }

  Future<void> _pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _selectedDocument = File(result.files.single.path!);
        _documentController.text = result.files.single.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                ClipPath(
                  clipper: ArcClipper(),
                  child: Container(
                    height: 190,
                    color: const Color.fromRGBO(87, 164, 91, 0.8),
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 10,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                  ),
                ),
                Positioned(
                  top: 50,
                  left: 50,
                  child: Text(
                    "Technical Support Inquiry ",
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.normal, color: Colors.black),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Image.asset(
              "assets/images/general.png",
              height: 150,
              width: 150,
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Title",
                      labelStyle: GoogleFonts.poppins(fontSize: 14,),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: "Description",
                      labelStyle: GoogleFonts.poppins(fontSize: 14,),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      labelText: "Date",
                      labelStyle: GoogleFonts.poppins(fontSize: 14,),
                      suffixIcon: IconButton(
                        onPressed: _pickDate,
                        icon: const Icon(Icons.calendar_month, color: Color.fromRGBO(87, 164, 91, 0.8)),
                      ),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    readOnly: true,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _imageController,
                    decoration: InputDecoration(
                      labelText: "Upload Image (optional)",
                      labelStyle: GoogleFonts.poppins(fontSize: 14,),
                      suffixIcon: IconButton(
                        onPressed: _pickImage,
                        icon: const Icon(Icons.image, color: Color.fromRGBO(87, 164, 91, 0.8)),
                      ),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    readOnly: true,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _documentController,
                    decoration: InputDecoration(
                      labelText: "Upload Document (optional)",
                      labelStyle: GoogleFonts.poppins(fontSize: 14,),
                      suffixIcon: IconButton(
                        onPressed: _pickDocument,
                        icon: const Icon(Icons.attach_file, color: Color.fromRGBO(87, 164, 91, 0.8)),
                      ),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    readOnly: true,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(87, 164, 91, 0.8),
                    ),
                    onPressed: () {},
                    child: Text(
                      "Submit",
                      style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}