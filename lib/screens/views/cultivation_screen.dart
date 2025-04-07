import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

class CultivationalScreen extends StatefulWidget {
  const CultivationalScreen({super.key});

  @override
  State<CultivationalScreen> createState() => _CultivationalScreenState();
}

class _CultivationalScreenState extends State<CultivationalScreen> {
  final storage = const FlutterSecureStorage();
  final Dio _dio = Dio();
  List<dynamic> _data = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    const url = "http://192.168.8.125:5000/api/fetch";

    try {
      final response = await _dio.get(url);
      
      if (response.statusCode == 200) {
        if (response.data != null && response.data is List) {
          setState(() {
            _data = response.data;
            _isLoading = false;
            _errorMessage = null;
          });
        } else {
          setState(() {
            _isLoading = false;
            _errorMessage = "Invalid data format received";
          });
        }
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = "Server error: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Failed to fetch data: ${e.toString()}";
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to fetch data"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return "Not specified";
    
    try {
      return DateFormat('yyyy/MM/dd').format(DateTime.parse(dateString));
    } catch (e) {
      return dateString; // Return raw string if parsing fails
    }
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isLoading = true;
    });
    await _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _errorMessage!,
                            style: GoogleFonts.poppins(
                              color: Colors.red,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _fetchData,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromRGBO(87, 164, 91, 0.8),
                            ),
                            child: Text(
                              "Retry",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : _data.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "No cultivation data available",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _fetchData,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromRGBO(87, 164, 91, 0.8),
                              ),
                              child: Text(
                                "Refresh",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            ClipPath(
                              clipper: ArcClipper(),
                              child: Container(
                                height: 190,
                                color: const Color.fromRGBO(87, 164, 91, 0.8),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 40),
                                    child: Text(
                                      "Cultivation Details",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            
                            // Display cultivation cards
                            ..._data.map((cultivation) {
                              final memberId = cultivation['memberId']?.toString() ?? 'N/A';
                              final cropCategory = cultivation['cropCategory']?.toString() ?? cultivation['category']?.toString() ?? 'N/A';
                              final cropName = cultivation['cropName']?.toString() ?? cultivation['crop']?.toString() ?? 'N/A';
                              final district = cultivation['district']?.toString() ?? 'N/A';
                              final city = cultivation['city']?.toString() ?? 'N/A';
                              final startDate = _formatDate(cultivation['startDate']?.toString());

                              return Card(
                                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: const BorderSide(
                                    color: Color.fromRGBO(87, 164, 91, 0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Member ID: $memberId",
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        "Category: $cropCategory",
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "Crop: $cropName",
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "Location: $district, $city",
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "Start Date: $startDate",
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      const Divider(height: 1, color: Colors.grey),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              // Add delete functionality
                                            },
                                            icon: const Icon(
                                              Icons.delete_outline,
                                              color: Colors.red,
                                              size: 24,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          IconButton(
                                            onPressed: () {
                                              Navigator.pushNamed(
                                                context,
                                                "/addCultivational",
                                                arguments: cultivation,
                                              ).then((_) => _fetchData());
                                            },
                                            icon: const Icon(
                                              Icons.edit_outlined,
                                              color: Color.fromRGBO(87, 164, 91, 0.8),
                                              size: 24,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),

                            const SizedBox(height: 20),
                            Image.asset(
                              "assets/images/image3.png",
                              height: 200,
                              width: 200,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, "/addCultivational")
                                      .then((_) => _fetchData());
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromRGBO(87, 164, 91, 0.8),
                                  minimumSize: const Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  "+ Add New Cultivation",
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
      ),
    );
  }
}