import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file/open_file.dart';

class GeneralIScreen extends StatefulWidget {
  const GeneralIScreen({super.key});

  @override
  State<GeneralIScreen> createState() => _GeneralIScreenState();
}

class _GeneralIScreenState extends State<GeneralIScreen> {
  DateTime? _selectedDate;
  final TextEditingController _IdescriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  final int _ImaxChars = 50;
  int _IcharCount = 0;

  @override
  void initState() {
    super.initState();
    _IdescriptionController.addListener(() {
      setState(() {
        _IcharCount = _IdescriptionController.text.length;
      });
    });
  }

  @override
  void dispose() {
    _dateController.dispose();
    _IdescriptionController.dispose();
    super.dispose();
  }

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
                    "General Inquiry",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.normal,
                        fontSize: 18,
                        color: Colors.black),
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
              child: Form(
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Title",
                        labelStyle: GoogleFonts.poppins(fontSize: 15),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      readOnly: true,
                      validator: (value) =>
                          value!.isEmpty ? "Please select a title" : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _IdescriptionController,
                      maxLength: _ImaxChars,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: "Description",
                        labelStyle: GoogleFonts.poppins(fontSize: 15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        counterText: "",
                      ),
                      validator: (value) =>
                          value!.isEmpty ? "Please enter description" : null,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        "$_IcharCount/$_ImaxChars",
                        style: GoogleFonts.poppins(
                          color: Colors.green.shade700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _dateController,
                      decoration: InputDecoration(
                        labelText: "Date",
                        labelStyle: GoogleFonts.poppins(fontSize: 15),
                        suffixIcon: IconButton(
                          onPressed: _pickDate,
                          icon: const Icon(Icons.calendar_month),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      readOnly: true,
                      validator: (value) =>
                          value!.isEmpty ? "Please select a date" : null,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style:ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(87, 164, 91, 0.8),

                      ),
                      onPressed: (){

                      },
                     child: Text("Submit",
                     style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color:Colors.white
                     ),
                     ),
                    ),
                    
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
