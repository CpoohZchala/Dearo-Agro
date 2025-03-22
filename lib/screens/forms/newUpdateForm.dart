import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:google_fonts/google_fonts.dart';

class NewUpdateForm extends StatefulWidget {
  const NewUpdateForm({super.key});

  @override
  State<NewUpdateForm> createState() => _NewUpdateFormState();
}

class _NewUpdateFormState extends State<NewUpdateForm> {
  DateTime? _selectedDate;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _controller = TextEditingController();
  final int _maxChars = 50;
  int _charCount = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _charCount = _controller.text.length;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _dateController.dispose();
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
            "\${pickedDate.year}-\${pickedDate.month.toString().padLeft(2, '0')}-\${pickedDate.day.toString().padLeft(2, '0')}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Stack(
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
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: Image.asset(
              "assets/icons/leaf.png",
              height: 35,
              width: 35,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 180),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      labelText: "Date",
                      labelStyle: GoogleFonts.poppins(
                        textStyle: TextStyle(fontSize: 15)
                      ),
                      suffixIcon: IconButton(
                        onPressed: _pickDate,
                        icon: const Icon(Icons.calendar_month),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    readOnly: true,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _controller,
                    maxLength: _maxChars,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: "Description about Crop update ..",
                      labelStyle: GoogleFonts.poppins(
                        textStyle: TextStyle(fontSize: 15)
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      counterText: "",
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      "$_charCount/$_maxChars",
                      style: GoogleFonts.poppins(
                        color: Colors.green.shade700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(87, 164, 91, 0.8),
                      padding: const EdgeInsets.all(15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Update Crop Status",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
