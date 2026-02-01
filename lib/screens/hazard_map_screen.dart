import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';

import '../services/hazard_api.dart';
import '../models/hazard.dart';
import 'hazard_list_screen.dart';
import 'report_hazard_screen.dart';

class HazardMapScreen extends StatefulWidget {
  const HazardMapScreen({super.key});

  @override
  State<HazardMapScreen> createState() => _HazardMapScreenState();
}

class _HazardMapScreenState extends State<HazardMapScreen> {

  final Set<Marker> markers = {};
  CameraPosition? initialCamera;

  BitmapDescriptor? fireIcon;
  BitmapDescriptor? floodIcon;
  BitmapDescriptor? accidentIcon;

  bool isLoading = true;

  // ================= INIT =================

  @override
  void initState() {
    super.initState();
    setupMap();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadHazards();
  }

  // ================= SETUP =================

  Future<void> setupMap() async {
    await loadIcons();
    await setInitialCamera();
    await loadHazards();

    setState(() {
      isLoading = false;
    });
  }

  // ================= CAMERA =================

  Future<void> setInitialCamera() async {
    try {
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      initialCamera = CameraPosition(
        target: LatLng(pos.latitude, pos.longitude),
        zoom: 16,
      );
    } catch (_) {
      initialCamera = const CameraPosition(
        target: LatLng(3.1390, 101.6869),
        zoom: 14,
      );
    }
  }

  // ================= ICONS =================

  Future<BitmapDescriptor> loadCustomIcon(String path) async {
    final data = await rootBundle.load(path);
    final bytes = data.buffer.asUint8List();
    return BitmapDescriptor.fromBytes(bytes);
  }

  Future<void> loadIcons() async {
    fireIcon = await loadCustomIcon("assets/icons/fire.png");
    floodIcon = await loadCustomIcon("assets/icons/flood.png");
    accidentIcon = await loadCustomIcon("assets/icons/accident.png");
  }

  // ================= LOAD HAZARDS =================

  Future<void> loadHazards() async {
    final hazards = await HazardApi.fetchHazards();

    setState(() {
      markers.clear();

      for (Hazard h in hazards) {

        BitmapDescriptor icon;

        if (h.title == "Fire") {
          icon = fireIcon!;
        } else if (h.title == "Flood") {
          icon = floodIcon!;
        } else {
          icon = accidentIcon!;
        }

        markers.add(
          Marker(
            markerId: MarkerId(h.id.toString()),
            position: LatLng(h.lat, h.lng),
            icon: icon,
            infoWindow: InfoWindow(
              title: h.title,
              snippet: h.description,
            ),
          ),
        );
      }
    });
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {

    if (isLoading || initialCamera == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),

      appBar: AppBar(
        backgroundColor: const Color(0xFF1F3A5F),
        title: const Text("Hazard Map"),
        centerTitle: true,
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
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFF39C12), // Orange
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ReportHazardScreen(),
            ),
          );

          // reload markers after adding
          loadHazards();
        },
      ),

      body: GoogleMap(
        initialCameraPosition: initialCamera!,
        markers: markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: false,
      ),
    );
  }
}
