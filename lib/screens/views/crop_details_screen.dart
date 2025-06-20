import 'package:dio/dio.dart';
import 'package:farmeragriapp/screens/forms/newUpdateForm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';

class CropDetailsScreen extends StatefulWidget {
  const CropDetailsScreen({super.key});

  @override
  State<CropDetailsScreen> createState() => _CropDetailsScreenState();
}

class _CropDetailsScreenState extends State<CropDetailsScreen> {
  final Dio _dio = Dio();
  final _storage = const FlutterSecureStorage();
  List<dynamic> _cropUpdates = [];
  bool _isLoading = true;
  // ignore: unused_field
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchCropUpdates();
  }

  Future<void> _fetchCropUpdates() async {
    try {
      final userId = await _storage.read(key: "userId");
      if (userId == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = "User not logged in";
        });
        return;
      }

      final response = await _dio.get("http://192.168.8.125:5000/api/cropfetch/$userId");
      
      if (response.statusCode == 200) {
        setState(() {
          _cropUpdates = response.data is List ? response.data : [];
          _isLoading = false;
          _errorMessage = null;
        });
      } else {
        throw Exception("Failed to load data");
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Error: ${e.toString()}";
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to fetch crop updates")),
      );
    }
  }

  Future<void> _deleteCropUpdate(String id) async {
  try {
    setState(() {
      _isLoading = true; // Show loading indicator
    });
    
    final response = await _dio.delete("http://192.168.8.125:5000/api/cropdelete/$id");
    
    if (response.statusCode == 200) {
      // Remove the item from local state immediately
      setState(() {
        _cropUpdates.removeWhere((update) => update['_id'] == id);
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.data["message"])),
      );
      
      // Optional: Refresh from server to confirm
      await _fetchCropUpdates();
    }
  } catch (e) {
    setState(() {
      _isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Failed to delete: ${e.toString()}")),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewUpdateForm()),
          );
          if (result == true) {
            _fetchCropUpdates();
          }
        },
        backgroundColor: const Color.fromRGBO(87, 164, 91, 0.8),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
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
                    "Crop Updates",
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
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _cropUpdates.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "No crop updates available",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Image.asset(
                              "assets/images/image5.png",
                              height: 250,
                              width: 250,
                            ),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            ..._cropUpdates.map((update) => _buildCropUpdateCard(
                                  update['addDate'],
                                  update['description'],
                                  update['_id'],
                                )),
                            const SizedBox(height: 20),
                            Image.asset(
                              "assets/images/image5.png",
                              height: 250,
                              width: 250,
                            ),
                            const SizedBox(height: 80),
                          ],
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildCropUpdateCard(String date, String description, String id) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(
          color: Color.fromRGBO(87, 164, 91, 0.8),
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.normal,
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => _showDeleteConfirmationDialog(id),
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 15),
                IconButton(
                  onPressed: () => _navigateToEditScreen(id),
                  icon: const Icon(
                    Icons.edit,
                    color: Color.fromRGBO(87, 164, 91, 0.8),
                    size: 20,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Delete", style: GoogleFonts.poppins(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        )),
        content: Text("Are you sure you want to delete this crop update?", 
          style: GoogleFonts.poppins(color: Colors.black)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: GoogleFonts.poppins(
              color: const Color.fromRGBO(87, 164, 91, 0.8),
            )),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteCropUpdate(id);
            },
            child: Text("Delete", style: GoogleFonts.poppins(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _navigateToEditScreen(String id) async {
    final updateToEdit = _cropUpdates.firstWhere((update) => update['_id'] == id);
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewUpdateForm(existingData: updateToEdit),
      ),
    );
    if (result == true) {
      _fetchCropUpdates();
    }
  }
}