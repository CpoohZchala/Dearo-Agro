import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CultivationalAddScreen extends StatefulWidget {
  const CultivationalAddScreen({super.key});

  @override
  State<CultivationalAddScreen> createState() => _CultivationalAddScreenState();
}

class _CultivationalAddScreenState extends State<CultivationalAddScreen> {
  final storage = const FlutterSecureStorage();
  String? _selectedCategory;
  String? _selectedCrop;
  String? _selectedDistrict;
  String? _selectedCity;
  DateTime? _selectedDate;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController memberIdController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  // Your existing cropCategories and districtCities maps remain the same
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
    "Gampaha": ["Gampaha", "Negombo", "Kadawatha", "Ja-Ela", "Ragama"],
    "Kalutara": ["Kalutara", "Panadura", "Beruwala", "Horana", "Matugama"],
    "Kandy": ["Kandy", "Peradeniya", "Katugastota", "Gampola", "Nawalapitiya"],
    "Matale": ["Matale", "Dambulla", "Galewela", "Ukuwela", "Rattota"],
    "Nuwara Eliya": ["Nuwara Eliya", "Hatton", "Talawakelle", "Watawala", "Ginigathhena"],
    "Galle": ["Galle", "Hikkaduwa", "Ambalangoda", "Karapitiya", "Baddegama"],
    "Matara": ["Matara", "Weligama", "Deniyaya", "Akurassa", "Kamburupitiya"],
    "Hambantota": ["Hambantota", "Tangalle", "Tissamaharama", "Beliatta", "Weeraketiya"],
    "Jaffna": ["Jaffna", "Nallur", "Chavakachcheri", "Point Pedro", "Kodikamam"],
    "Kilinochchi": ["Kilinochchi", "Pallai", "Paranthan", "Mulankavil", "Tharmapuram"],
    "Mannar": ["Mannar", "Pesalai", "Murunkan", "Adampan", "Madhu"],
    "Vavuniya": ["Vavuniya", "Cheddikulam", "Nedunkeni", "Omanthai", "Pampaimadu"],
    "Mullaitivu": ["Mullaitivu", "Puthukudiyiruppu", "Oddusuddan", "Thunukkai", "Maritimepattu"],
    "Batticaloa": ["Batticaloa", "Eravur", "Kattankudy", "Kaluwanchikudy", "Vakarai"],
    "Ampara": ["Ampara", "Kalmunai", "Sainthamaruthu", "Akkaraipattu", "Sammanthurai"],
    "Trincomalee": ["Trincomalee", "Kinniya", "Mutur", "Kantale", "Nilaveli"],
    "Kurunegala": ["Kurunegala", "Kuliyapitiya", "Wariyapola", "Mawathagama", "Narammala"],
    "Puttalam": ["Puttalam", "Chilaw", "Wennappuwa", "Anamaduwa", "Nattandiya"],
    "Anuradhapura": ["Anuradhapura", "Kekirawa", "Medawachchiya", "Thambuttegama", "Nochchiyagama"],
    "Polonnaruwa": ["Polonnaruwa", "Hingurakgoda", "Medirigiriya", "Dimbulagala", "Elahera"],
    "Badulla": ["Badulla", "Bandarawela", "Haputale", "Welimada", "Mahiyanganaya"],
    "Monaragala": ["Monaragala", "Wellawaya", "Bibila", "Medagama", "Buttala"],
    "Ratnapura": ["Ratnapura", "Embilipitiya", "Balangoda", "Pelmadulla", "Godakawela"],
    "Kegalle": ["Kegalle", "Mawanella", "Warakapola", "Rambukkana", "Dehiowita"],
  };


  List<String> _getCrops(String category) => cropCategories[category] ?? [];
  List<String> _getCities(String district) => districtCities[district] ?? [];

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
        _dateController.text = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _submitData() async {
    final dio = Dio();
    const url = "http://192.168.8.125:5000/api/submit";

    try {
      final response = await dio.post(url, data: {
        "memberId": memberIdController.text,
        "cropCategory": _selectedCategory,
        "cropName": _selectedCrop,
        "address": addressController.text,
        "startDate": _selectedDate?.toIso8601String() ?? "",
        "district": _selectedDistrict,
        "city": _selectedCity,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.data["message"])),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to submit data")),
      );
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
                  top: 40,
                  right: 20,
                  child: Image.asset(
                    "assets/icons/man.png",
                    width: 35,
                    height: 35,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              "Cultivational Details",
              style: GoogleFonts.openSans(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: const Color.fromRGBO(87, 164, 91, 1),
              ),
            ),
            const SizedBox(height: 10),
            _buildTextField("Type Your Member ID", memberIdController),
            _buildDropdown("Select Category", cropCategories.keys.toList(), (val) {
              setState(() {
                _selectedCategory = val;
                _selectedCrop = null;
              });
            }),
            _buildDropdown("Select Crop", _selectedCategory != null ? _getCrops(_selectedCategory!) : [], (val) {
              setState(() {
                _selectedCrop = val;
              });
            }),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: "Start Date",
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
            ),
            _buildDropdown("Select District", districtCities.keys.toList(), (val) {
              setState(() {
                _selectedDistrict = val;
              });
            }),
            _buildDropdown("Select City", _selectedDistrict != null ? _getCities(_selectedDistrict!) : [], (val) {
              setState(() {
                _selectedCity = val;
              });
            }),
            _buildTextField("Location Address Type Here", addressController),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _submitData,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(87, 164, 91, 1),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              ),
              child: const Text(
                "Submit",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        value: label == "Select Category" ? _selectedCategory : 
               label == "Select Crop" ? _selectedCrop :
               label == "Select District" ? _selectedDistrict :
               _selectedCity,
        onChanged: onChanged,
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item.trim()),
          );
        }).toList(),
      ),
    );
  }
}