import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:google_fonts/google_fonts.dart';

class CultivationalAddScreen extends StatefulWidget {
  const CultivationalAddScreen({super.key});

  @override
  State<CultivationalAddScreen> createState() => _CultivationalAddScreenState();
}

class _CultivationalAddScreenState extends State<CultivationalAddScreen> {
  
  String? _selectedCategory;
  String? _selectedCrop;
  String? _selectedDestrict;
  String? _selectedCity;

 


  // Crop Categories and Crops
  final Map<String, List<String>> _cropData = {
    "Cereal Crops (Grains)": ["Rice", "Wheat", "Maize", "Barley"],
    "Vegetable Crops": ["Tomato", "Carrot", "Spinach", "Potato"],
    "Fruit Crops": ["Mango", "Apple", "Banana", "Orange"],
    "Commercial Crops": ["Sugarcane", "Cotton", "Tea", "Coffee"],
    "Spices and Condiments": ["Pepper", "Cardamom", "Turmeric", "Ginger"],
    "Medicinal and Aromatic Crops": ["Aloe Vera", "Tulsi", "Mint", "Lavender"],
  };

  List<String> _cropList = []; // Dynamic crop list

  final Map<String, List<String>> districtsAndCities = {
    "Ampara": ["Ampara", "Kalmunai", "Sainthamaruthu"],
    "Anuradhapura": ["Anuradhapura", "Mihintale", "Kekirawa"],
    "Badulla": ["Badulla", "Bandarawela", "Haputale"],
    "Batticaloa": ["Batticaloa", "Kattankudy", "Eravur"],
    "Colombo": [
      "Colombo",
      "Sri Jayawardenepura Kotte",
      "Dehiwala-Mount Lavinia"
    ],
    "Galle": ["Galle", "Hikkaduwa", "Ambalangoda"],
    "Gampaha": ["Gampaha", "Negombo", "Wattala"],
    "Hambantota": ["Hambantota", "Tangalle", "Tissamaharama"],
    "Jaffna": ["Jaffna", "Chavakachcheri", "Point Pedro"],
    "Kalutara": ["Kalutara", "Beruwala", "Panadura"],
    "Kandy": ["Kandy", "Peradeniya", "Gampola"],
    "Kegalle": ["Kegalle", "Mawanella", "Rambukkana"],
    "Kilinochchi": ["Kilinochchi", "Paranthan"],
    "Kurunegala": ["Kurunegala", "Kuliyapitiya", "Melsiripura"],
    "Mannar": ["Mannar", "Pesalai"],
    "Matale": ["Matale", "Dambulla", "Sigiriya"],
    "Matara": ["Matara", "Weligama", "Mirissa"],
    "Monaragala": ["Monaragala", "Wellawaya", "Bibile"],
    "Mullaitivu": ["Mullaitivu", "Puthukkudiyiruppu"],
    "Nuwara Eliya": ["Nuwara Eliya", "Hatton", "Talawakele"],
    "Polonnaruwa": ["Polonnaruwa", "Hingurakgoda", "Medirigiriya"],
    "Puttalam": ["Puttalam", "Chilaw", "Wennappuwa"],
    "Ratnapura": ["Ratnapura", "Balangoda", "Eheliyagoda"],
    "Trincomalee": ["Trincomalee", "Kinniya", "Kantale"],
    "Vavuniya": ["Vavuniya", "Cheddikulam"],
  };

  List<String> _cityList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipPath(
              clipper: ArcClipper(),
              child: Container(
                height: 190,
                color: const Color.fromRGBO(87, 164, 91, 0.8),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back_ios),
                      ),
                      Image.asset(
                        "assets/icons/man.png",
                        width: 35,
                        height: 35,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),

            _buildTextField("Type Your Member ID "),

            // **Select Your Crop Category Dropdown**
            Padding(
              padding: const EdgeInsets.all(10),
              child: DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  labelText: "Select Your Crop Category",
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 95, 94, 94),
                        width: 1.5), // Border when not focused
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromRGBO(19, 146, 25, 0.8),
                        width: 3), // Border when focused
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: _cropData.keys.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category,
                        style: GoogleFonts.poppins(fontSize: 15)),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                    _cropList = _cropData[newValue] ?? [];
                    _selectedCrop = null; // Reset crop selection
                  });
                },
              ),
            ),

            // **Select Your Crop Dropdown**
            Padding(
              padding: const EdgeInsets.all(10),
              child: DropdownButtonFormField<String>(
                value: _selectedCrop,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  labelText: "Select Your Crop",
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 95, 94, 94),
                        width: 1.5), // Border when not focused
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromRGBO(19, 146, 25, 0.8),
                        width: 3), // Border when focused
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: _cropList.map((String crop) {
                  return DropdownMenuItem<String>(
                    value: crop,
                    child: Text(crop, style: GoogleFonts.poppins(fontSize: 15)),
                  );
                }).toList(),
                onChanged: _cropList.isNotEmpty
                    ? (String? newValue) {
                        setState(() {
                          _selectedCrop = newValue;
                        });
                      }
                    : null, // Disable if category is not selected
              ),
            ),

            _buildTextField("Location Address Type here"),
            _buildTextField("Start Date ",),

            // **Select Your Destrict Dropdown**
            Padding(
              padding: const EdgeInsets.all(10),
              child: DropdownButtonFormField<String>(
                value: _selectedDestrict,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  labelText: "Select Your Destrict",
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 95, 94, 94),
                        width: 1.5), // Border when not focused
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromRGBO(19, 146, 25, 0.8),
                        width: 3), // Border when focused
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: districtsAndCities.keys.map((String destricts) {
                  return DropdownMenuItem<String>(
                    value: destricts,
                    child: Text(destricts,
                        style: GoogleFonts.poppins(fontSize: 15)),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedDestrict = newValue;
                    _cityList = districtsAndCities[newValue] ?? [];
                    _selectedCity = (_cityList.contains(_selectedCity)) ? _selectedCity : null;  // Reset crop selection
                  });
                },
              ),
            ),

            // **Select Your Crop Dropdown**
            Padding(
              padding: const EdgeInsets.all(10),
              child: DropdownButtonFormField<String>(
                 value: _cityList.contains(_selectedCity) ? _selectedCity : null,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  labelText: "Select Your City",
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 95, 94, 94),
                        width: 1.5), // Border when not focused
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromRGBO(19, 146, 25, 0.8),
                        width: 3), // Border when focused
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: _cityList.map((String city) {
                  return DropdownMenuItem<String>(
                    value: city,
                    child: Text(city, style: GoogleFonts.poppins(fontSize: 15)),
                  );
                }).toList(),
                onChanged: _cityList.isNotEmpty
                    ? (String? newValue) {
                        setState(() {
                          _selectedDestrict = newValue;
                        });
                      }
                    : null, // Disable if category is not selected
              ),
            ),
          ],
        ),
      ),
    );
  }

  // **Reusable Text Field**
  Widget _buildTextField(String label) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(fontSize: 15),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
                color: Color.fromRGBO(19, 146, 25, 0.8), width: 3),
          ),
        ),
      ),
    );
  }
}
