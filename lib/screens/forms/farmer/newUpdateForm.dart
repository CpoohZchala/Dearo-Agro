import 'package:farmeragriapp/api/crop_update_api.dart';
import 'package:farmeragriapp/models/crop_update_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:google_fonts/google_fonts.dart';

class NewUpdateForm extends StatefulWidget {
  final dynamic existingData;

  const NewUpdateForm({super.key, this.existingData});

  @override
  State<NewUpdateForm> createState() => _NewUpdateFormState();
}

class _NewUpdateFormState extends State<NewUpdateForm> {
  DateTime? _selectedDate;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final int _maxChars = 50;
  int _charCount = 0;
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  final TextEditingController _fertilizerTypeController =
      TextEditingController();
  final TextEditingController _fertilizerAmountController =
      TextEditingController();
  String? _selectedFertilizerUnit;

  final List<String> _fertilizerUnits = ['Kg', 'g', 'l', 'ml'];

  final List<String> _cropUpdateOptions = [
    "බිම සකස් කිරීම",
    "බීජ තේරීම සහ බීජ වගාව",
    "රෝපණය (වගා කිරීම)",
    "පොහොර යෙදීම",
    "ජල සපයීම (පෙරලීම)",
    "වාලි කිරීම සහ නියමිත පාලනය",
    "වර්ධනය පරික්ෂා කිරීම",
    "අස්වනු තක්සේරු කිරීම",
    "අස්වනු කිරීම",
    "අස්වනු ගබඩා කිරීම",
    "අස්වනු බෙදාහැරීම"
  ];

  String? _selectedDescription;
  @override
  void initState() {
    super.initState();
    _descriptionController.addListener(_updateCharCount);
    _initializeFormData();
  }

  void _updateCharCount() {
    setState(() {
      _charCount = _descriptionController.text.length;
    });
  }

  void _initializeFormData() {
    if (widget.existingData != null) {
      _descriptionController.text = widget.existingData['description'] ?? '';
      _selectedDescription = widget.existingData['description'];
      _dateController.text = widget.existingData['addDate'] ?? '';
      _parseExistingDate();
    }
  }

  void _parseExistingDate() {
    if (widget.existingData['addDate'] != null) {
      try {
        final parts = widget.existingData['addDate'].split('-');
        if (parts.length == 3) {
          _selectedDate = DateTime(
            int.parse(parts[0]),
            int.parse(parts[1]),
            int.parse(parts[2]),
          );
        }
      } catch (e) {
        debugPrint("Error parsing date: $e");
      }
    }
  }

  @override
  void dispose() {
    _descriptionController.removeListener(_updateCharCount);
    _descriptionController.dispose();
    _dateController.dispose();
    _fertilizerTypeController.dispose();
    _fertilizerAmountController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = _formatDate(pickedDate);
      });
    }
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      // Build the request body
      final Map<String, dynamic> updateData = {
        'id': widget.existingData != null ? widget.existingData['_id'] : null,
        'memberId': "",
        'addDate': _dateController.text,
        'description': _descriptionController.text,
      };

      // Add fertilizer fields only if description is "පොහොර යෙදීම"
      if (_selectedDescription == "පොහොර යෙදීම") {
        updateData['fertilizerType'] = _fertilizerTypeController.text;
        updateData['fertilizerAmount'] =
            double.tryParse(_fertilizerAmountController.text) ?? 0;
        updateData['fertilizerUnit'] = _selectedFertilizerUnit;
      }

      print(updateData); // <-- Add this line to log the request body

      // If you use a model, update this part accordingly
      final update = CropUpdate.fromJson(updateData);

      final message = await CropUpdateApi().submitCropUpdate(
        update,
        isUpdate: widget.existingData != null,
      );

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  // Add this list to your state class
  final List<String> _fertilizerTypeOptions = [
    "ජෛව පොහොර (Organic)",
    "රසායනික පොහොර (Chemical)",
    "මිශ්‍ර පොහොර (Mixed or Compound)"
  ];

  int _daysSinceAddDate(String? addDate) {
    if (addDate == null || addDate.isEmpty) return 0;
    try {
      final start = DateTime.parse(addDate);
      final now = DateTime.now();
      return now.difference(start).inDays;
    } catch (e) {
      return 0;
    }
  }

  Widget _buildCropUpdateCard(String date, String description, String id) {
    final showDays = description == "රෝපණය (වගා කිරීම)";
    final days = showDays ? _daysSinceAddDate(date) : null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showDays)
              Text(
                "පැල වලට දින ගණන: $days",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.green[700],
                ),
              ),
          ],
        ),
      ),
    );
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
              onPressed: () => Navigator.pop(context),
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
          Positioned(
            top: 50,
            left: 50,
            right: 0,
            child: Text(
              widget.existingData != null
                  ? "Edit Crop Update"
                  : "New Crop Update",
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 180),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _dateController,
                      decoration: InputDecoration(
                        labelText: "Date",
                        labelStyle: GoogleFonts.poppins(
                            fontSize: 15,
                            color: const Color.fromRGBO(87, 164, 91, 0.8)),
                        suffixIcon: IconButton(
                          onPressed: _pickDate,
                          icon: const Icon(Icons.calendar_month),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(87, 164, 91, 0.8),
                            width: 2,
                          ),
                        ),
                      ),
                      readOnly: true,
                      validator: (value) => value == null || value.isEmpty
                          ? "Please select a date"
                          : null,
                    ),
                    const SizedBox(height: 10),
                    // Dropdown for crop update description
                    DropdownButtonFormField<String>(
                      value: _selectedDescription,
                      decoration: InputDecoration(
                        labelText: "Select Crop Update",
                        labelStyle: GoogleFonts.poppins(
                            fontSize: 15,
                            color: const Color.fromRGBO(87, 164, 91, 0.8)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(87, 164, 91, 0.8),
                            width: 2,
                          ),
                        ),
                      ),
                      items: _cropUpdateOptions.map((option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(option, style: GoogleFonts.poppins()),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedDescription = value;
                          _descriptionController.text = value ?? '';
                          // Reset fertilizer fields if not selected
                          if (value != "පොහොර යෙදීම") {
                            _fertilizerTypeController.clear();
                            _fertilizerAmountController.clear();
                            _selectedFertilizerUnit = null;
                          }
                        });
                      },
                      validator: (value) => value == null || value.isEmpty
                          ? "Please select a crop update"
                          : null,
                    ),
                    const SizedBox(height: 10),
                    // Show fertilizer fields only if "පොහොර යෙදීම" is selected
                    if (_selectedDescription == "පොහොර යෙදීම") ...[
                      DropdownButtonFormField<String>(
                        value: _fertilizerTypeController.text.isNotEmpty
                            ? _fertilizerTypeController.text
                            : null,
                        decoration: InputDecoration(
                          labelText: "පොහොර වර්ගය",
                          labelStyle: GoogleFonts.poppins(
                              fontSize: 15,
                              color: const Color.fromRGBO(87, 164, 91, 0.8)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color.fromRGBO(87, 164, 91, 0.8),
                              width: 2,
                            ),
                          ),
                        ),
                        items: _fertilizerTypeOptions.map((type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(type, style: GoogleFonts.poppins()),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _fertilizerTypeController.text = value ?? '';
                          });
                        },
                        validator: (value) => value == null || value.isEmpty
                            ? "Please select fertilizer type"
                            : null,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: _fertilizerAmountController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: "Amount",
                                labelStyle: GoogleFonts.poppins(
                                    fontSize: 15,
                                    color:
                                        const Color.fromRGBO(87, 164, 91, 0.8)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Color.fromRGBO(87, 164, 91, 0.8),
                                    width: 2,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (_selectedDescription == "පොහොර යෙදීම") {
                                  if (value == null || value.isEmpty) {
                                    return "Enter amount";
                                  }
                                  if (double.tryParse(value) == null) {
                                    return "Enter valid number";
                                  }
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 1,
                            child: DropdownButtonFormField<String>(
                              value: _selectedFertilizerUnit,
                              decoration: InputDecoration(
                                labelText: "Unit",
                                labelStyle: GoogleFonts.poppins(
                                    fontSize: 15,
                                    color:
                                        const Color.fromRGBO(87, 164, 91, 0.8)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Color.fromRGBO(87, 164, 91, 0.8),
                                    width: 2,
                                  ),
                                ),
                              ),
                              items: _fertilizerUnits.map((unit) {
                                return DropdownMenuItem<String>(
                                  value: unit,
                                  child:
                                      Text(unit, style: GoogleFonts.poppins()),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedFertilizerUnit = value;
                                });
                              },
                              validator: (value) {
                                if (_selectedDescription == "පොහොර යෙදීම" &&
                                    (value == null || value.isEmpty)) {
                                  return "Select unit";
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                    TextFormField(
                      controller: _descriptionController,
                      maxLength: _maxChars,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: "Description about Crop update..",
                        labelStyle: GoogleFonts.poppins(
                            fontSize: 15,
                            color: const Color.fromRGBO(87, 164, 91, 0.8)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(87, 164, 91, 0.8),
                            width: 2,
                          ),
                        ),
                        counterText: "",
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? "Please enter a description"
                          : null,
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
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(87, 164, 91, 0.8),
                          padding: const EdgeInsets.all(15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isSubmitting
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : Text(
                                widget.existingData != null
                                    ? "Update"
                                    : "Submit",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
