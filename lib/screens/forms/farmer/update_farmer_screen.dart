import 'package:farmeragriapp/api/farmer_api.dart';
import 'package:farmeragriapp/models/farmer_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UpdateFarmerScreen extends StatefulWidget {
  const UpdateFarmerScreen({Key? key}) : super(key: key);

  @override
  State<UpdateFarmerScreen> createState() => _UpdateFarmerScreenState();
}

class _UpdateFarmerScreenState extends State<UpdateFarmerScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final farmer = ModalRoute.of(context)!.settings.arguments as Farmer;
    fullNameController.text = farmer.fullName;
    mobileNumberController.text = farmer.mobileNumber;
  }

  Future<void> updateFarmer(String id) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      await FarmerApi.updateFarmer(
        id,
        Farmer(
          id: id,
          fullName: fullNameController.text,
          mobileNumber: mobileNumberController.text,
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Farmer updated successfully')),
      );
      Navigator.pop(context, true); // Return true to indicate success
    } catch (error) {
      print('Error updating farmer: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update farmer')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final farmer = ModalRoute.of(context)!.settings.arguments as Farmer;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Update Farmer",
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 2, 17, 72),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: fullNameController,
                decoration: InputDecoration(
                  labelText: "Full Name",
                  labelStyle: GoogleFonts.poppins(fontSize: 16),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the full name";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: mobileNumberController,
                decoration: InputDecoration(
                  labelText: "Mobile Number",
                  labelStyle: GoogleFonts.poppins(fontSize: 16),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the mobile number";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () => updateFarmer(farmer.id),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 2, 17, 72),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        "Update Farmer",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
