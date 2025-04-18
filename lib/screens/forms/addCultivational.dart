import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CultivationalAddScreen extends StatefulWidget {
  final dynamic existingData;

  const CultivationalAddScreen({super.key, this.existingData});

  @override
  State<CultivationalAddScreen> createState() => _CultivationalAddScreenState();
}

class _CultivationalAddScreenState extends State<CultivationalAddScreen> {
  final storage = const FlutterSecureStorage();
  final Dio _dio = Dio();
  String? _selectedCategory;
  String? _selectedCrop;
  String? _selectedDistrict;
  String? _selectedCity;
  DateTime? _selectedDate;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController memberIdController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  bool _isSubmitting = false;

  final Map<String, List<String>> cropCategories = {
    "Cereal Crops": ["Rice", "Wheat", "Maize (Corn)", "Barley"],
    "Root and Tuber Crops": ["Potato", "Cassava", "Carrot"],
    "Fruit Crops": ["Apple", "Banana", "Mango", "Grapes"],
    "Vegetable Crops": ["Tomato", "Cabbage", "Cucumber", "Onion"],
    "Beverage Crops": ["Tea", "Coffee", "Cocoa"],
    "Medicinal and Aromatic Crops": ["Aloe Vera", "Neem", "Lavender"]
  };

  final Map<String, List<String>> districtCities = {
    "Colombo": ["Colombo", "Dehiwala", "Moratuwa", "Nugegoda", "Kottawa"],
    "Colombo": ["Colombo", "Dehiwala", "Moratuwa", "Nugegoda", "Kottawa"],
    "Gampaha": ["Gampaha", "Negombo", "Kadawatha", "Ja-Ela", "Ragama"],
    "Kalutara": ["Kalutara", "Panadura", "Beruwala", "Horana", "Matugama"],
    "Kandy": ["Kandy", "Peradeniya", "Katugastota", "Gampola", "Nawalapitiya"],
    "Matale": ["Matale", "Dambulla", "Galewela", "Ukuwela", "Rattota"],
    "Nuwara Eliya": [
      "Nuwara Eliya",
      "Hatton",
      "Talawakelle",
      "Watawala",
      "Ginigathhena"
    ],
    "Galle": ["Galle", "Hikkaduwa", "Ambalangoda", "Karapitiya", "Baddegama"],
    "Matara": ["Matara", "Weligama", "Deniyaya", "Akurassa", "Kamburupitiya"],
    "Hambantota": [
      "Hambantota",
      "Tangalle",
      "Tissamaharama",
      "Beliatta",
      "Weeraketiya"
    ],
    "Jaffna": [
      "Jaffna",
      "Nallur",
      "Chavakachcheri",
      "Point Pedro",
      "Kodikamam"
    ],
    "Kilinochchi": [
      "Kilinochchi",
      "Pallai",
      "Paranthan",
      "Mulankavil",
      "Tharmapuram"
    ],
    "Mannar": ["Mannar", "Pesalai", "Murunkan", "Adampan", "Madhu"],
    "Vavuniya": [
      "Vavuniya",
      "Cheddikulam",
      "Nedunkeni",
      "Omanthai",
      "Pampaimadu"
    ],
    "Mullaitivu": [
      "Mullaitivu",
      "Puthukudiyiruppu",
      "Oddusuddan",
      "Thunukkai",
      "Maritimepattu"
    ],
    "Batticaloa": [
      "Batticaloa",
      "Eravur",
      "Kattankudy",
      "Kaluwanchikudy",
      "Vakarai"
    ],
    "Ampara": [
      "Ampara",
      "Kalmunai",
      "Sainthamaruthu",
      "Akkaraipattu",
      "Sammanthurai"
    ],
    "Trincomalee": ["Trincomalee", "Kinniya", "Mutur", "Kantale", "Nilaveli"],
    "Kurunegala": [
      "Kurunegala",
      "Kuliyapitiya",
      "Wariyapola",
      "Mawathagama",
      "Narammala"
    ],
    "Puttalam": ["Puttalam", "Chilaw", "Wennappuwa", "Anamaduwa", "Nattandiya"],
    "Anuradhapura": [
      "Anuradhapura",
      "Kekirawa",
      "Medawachchiya",
      "Thambuttegama",
      "Nochchiyagama"
    ],
    "Polonnaruwa": [
      "Polonnaruwa",
      "Hingurakgoda",
      "Medirigiriya",
      "Dimbulagala",
      "Elahera"
    ],
    "Badulla": [
      "Badulla",
      "Bandarawela",
      "Haputale",
      "Welimada",
      "Mahiyanganaya"
    ],
    "Monaragala": ["Monaragala", "Wellawaya", "Bibila", "Medagama", "Buttala"],
    "Ratnapura": [
      "Ratnapura",
      "Embilipitiya",
      "Balangoda",
      "Pelmadulla",
      "Godakawela"
    ],
    "Kegalle": [
      "Kegalle",
      "Mawanella",
      "Warakapola",
      "Rambukkana",
      "Dehiowita"
    ],
  };

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final userId = await storage.read(key: "userId");
    memberIdController.text = userId ?? '';

    if (widget.existingData != null) {
      setState(() {
        _selectedCategory = widget.existingData['cropCategory'] ??
            widget.existingData['category'];
        _selectedCrop =
            widget.existingData['cropName'] ?? widget.existingData['crop'];
        _selectedDistrict = widget.existingData['district'];
        _selectedCity = widget.existingData['city'];
        addressController.text = widget.existingData['address'] ?? '';

        if (widget.existingData['startDate'] != null) {
          try {
            _selectedDate = DateTime.parse(widget.existingData['startDate']);
            _dateController.text =
                "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}";
          } catch (e) {
            print("Error parsing date: $e");
          }
        }
      });
    }
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
        _dateController.text =
            "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      });
    }
  }

  bool _validateForm() {
    return _selectedCategory != null &&
        _selectedCrop != null &&
        _selectedDate != null &&
        _selectedDistrict != null &&
        _selectedCity != null &&
        addressController.text.isNotEmpty &&
        memberIdController.text.isNotEmpty;
  }

  Future<void> _submitData() async {
    if (!_validateForm()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final url =
          "http://192.168.8.125:5000/api/${widget.existingData != null ? 'update' : 'submit'}";
      final data = {
        "memberId": memberIdController.text,
        "cropCategory": _selectedCategory,
        "cropName": _selectedCrop,
        "address": addressController.text,
        "startDate": _selectedDate?.toIso8601String(),
        "district": _selectedDistrict,
        "city": _selectedCity,
      };

      Response response;
      if (widget.existingData != null) {
        data['id'] = widget.existingData['_id'];
        response = await _dio.put(url, data: data);
      } else {
        response = await _dio.post(url, data: data);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.data["message"])),
      );
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    } finally {
      setState(() => _isSubmitting = false);
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
                  right: 0,
                  child: Text(
                    "Edit Your Details",
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  right: 20,
                  child: Image.asset(
                    "assets/icons/man.png",
                    width: 35,
                    height: 35,
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      widget.existingData != null
                          ? "Edit Cultivation"
                          : "Add Cultivation",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildTextField("Member ID", memberIdController,
                      enabled: false),
                  const SizedBox(height: 16),
                  _buildDropdown(
                      "Select Category*", cropCategories.keys.toList(), (val) {
                    setState(() {
                      _selectedCategory = val;
                      _selectedCrop = null; // Reset crop when category changes
                    });
                  }, value: _selectedCategory),
                  const SizedBox(height: 16),
                  _buildDropdown(
                      "Select Crop*",
                      _selectedCategory != null
                          ? cropCategories[_selectedCategory]!
                          : [],
                      (val) => setState(() => _selectedCrop = val),
                      value: _selectedCrop,
                      enabled: _selectedCategory != null),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      labelText: "Start Date*",
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_month),
                        onPressed: _pickDate,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    readOnly: true,
                  ),
                  const SizedBox(height: 16),
                  _buildDropdown(
                      "Select District*",
                      districtCities.keys.toList(),
                      (val) => setState(() {
                            _selectedDistrict = val;
                            _selectedCity =
                                null; 
                          }),
                      value: _selectedDistrict),
                  const SizedBox(height: 16),
                  _buildDropdown(
                      "Select City*",
                      _selectedDistrict != null
                          ? districtCities[_selectedDistrict]!
                          : [],
                      (val) => setState(() => _selectedCity = val),
                      value: _selectedCity,
                      enabled: _selectedDistrict != null),
                  const SizedBox(height: 16),
                  _buildTextField("Location Address*", addressController),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submitData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(87, 164, 91, 1),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: _isSubmitting
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              widget.existingData != null ? "UPDATE" : "SUBMIT",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool enabled = true}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      enabled: enabled,
    );
  }

  Widget _buildDropdown(
      String label, List<String> items, Function(String?) onChanged,
      {String? value, bool enabled = true}) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      value: value,
      onChanged: enabled ? onChanged : null,
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      validator: (value) => value == null ? 'This field is required' : null,
    );
  }
}
