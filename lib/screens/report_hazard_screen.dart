import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';

import '../models/hazard.dart';
import '../services/hazard_api.dart';
import 'hazard_list_screen.dart';

class ReportHazardScreen extends StatefulWidget {
  const ReportHazardScreen({super.key});

  @override
  State<ReportHazardScreen> createState() => _ReportHazardScreenState();
}

class _ReportHazardScreenState extends State<ReportHazardScreen> {

  double latitude = 0.0;
  double longitude = 0.0;
  String? selectedType;
  bool isSubmitting = false;

  final TextEditingController descriptionController =
  TextEditingController();

  String locationText = "No location yet";

  // ---------- LOGOUT ----------
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', false);
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  // ---------- GET LOCATION ----------
  Future<void> getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showMsg("Enable location services");
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showMsg("Location permission denied");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showMsg("Enable location permission in settings");
      await Geolocator.openAppSettings();
      return;
    }

    final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    if (!mounted) return;

    setState(() {
      latitude = pos.latitude;
      longitude = pos.longitude;
      locationText =
      "Lat: ${latitude.toStringAsFixed(5)}, Lng: ${longitude.toStringAsFixed(5)}";
    });
  }

  // ---------- SUBMIT ----------
  Future<void> submitHazard() async {
    if (selectedType == null ||
        descriptionController.text.isEmpty ||
        latitude == 0.0 ||
        longitude == 0.0) {
      showMsg("Fill all fields and get location");
      return;
    }

    setState(() => isSubmitting = true);

    final hazard = Hazard(
      id: DateTime.now().millisecondsSinceEpoch,
      title: selectedType!,
      description: descriptionController.text,
      lat: latitude,
      lng: longitude,
      reportedAt: DateTime.now(),
    );

    try {
      await HazardApi.sendHazard(hazard);

      if (!mounted) return;

      showMsg("Hazard saved successfully");

      Navigator.pop(context);

    } catch (e) {
      showMsg("Failed to save hazard");
    } finally {
      if (mounted) {
        setState(() => isSubmitting = false);
      }
    }
  }

  // ---------- SNACKBAR ----------
  void showMsg(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  // ---------- UI ----------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),

      appBar: AppBar(
        backgroundColor: const Color(0xFF1F3A5F),
        title: const Text("Report Hazard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const HazardListScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout,
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),

            child: Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text(
                    "Hazard Information",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  // TYPE
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: "Hazard Type",
                      prefixIcon: Icon(Icons.warning),
                      border: OutlineInputBorder(),
                    ),
                    value: selectedType,
                    items: const [
                      DropdownMenuItem(value: "Fire", child: Text("Fire")),
                      DropdownMenuItem(value: "Flood", child: Text("Flood")),
                      DropdownMenuItem(value: "Accident", child: Text("Accident")),
                    ],
                    onChanged: (value) {
                      setState(() => selectedType = value);
                    },
                  ),

                  const SizedBox(height: 15),

                  // DESCRIPTION
                  TextField(
                    controller: descriptionController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: "Description",
                      prefixIcon: Icon(Icons.description),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // LOCATION BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.location_on),
                      label: const Text("Get Current Location"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1F3A5F),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: getLocation,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    locationText,
                    style: const TextStyle(fontSize: 13),
                  ),

                  const SizedBox(height: 30),

                  // SUBMIT
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF39C12),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: isSubmitting ? null : submitHazard,
                      child: isSubmitting
                          ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                          : const Text(
                        "Submit Hazard",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
