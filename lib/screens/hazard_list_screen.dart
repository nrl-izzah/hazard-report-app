import 'package:flutter/material.dart';
import '../services/hazard_api.dart';
import '../models/hazard.dart';

class HazardListScreen extends StatefulWidget {
  const HazardListScreen({super.key});

  @override
  State<HazardListScreen> createState() => _HazardListScreenState();
}

class _HazardListScreenState extends State<HazardListScreen> {

  late Future<List<Hazard>> hazardsFuture;

  @override
  void initState() {
    super.initState();
    hazardsFuture = HazardApi.fetchHazards();
  }

  Future<void> refresh() async {
    setState(() {
      hazardsFuture = HazardApi.fetchHazards();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),

      appBar: AppBar(
        backgroundColor: const Color(0xFF1F3A5F),
        title: const Text("Reported Hazards"),
        centerTitle: true,
      ),

      body: FutureBuilder<List<Hazard>>(
        future: hazardsFuture,
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("No hazards yet"),
            );
          }

          final hazards = snapshot.data!;

          return RefreshIndicator(
            onRefresh: refresh,
            child: ListView.builder(
              itemCount: hazards.length,
              itemBuilder: (context, index) {

                final h = hazards[index];

                IconData icon;
                Color color;

                if (h.title == "Fire") {
                  icon = Icons.local_fire_department;
                  color = Colors.red;
                } else if (h.title == "Flood") {
                  icon = Icons.water;
                  color = Colors.blue;
                } else {
                  icon = Icons.car_crash;
                  color = Colors.orange;
                }

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: color,
                      child: Icon(icon, color: Colors.white),
                    ),

                    title: Text(
                      h.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(h.description),
                        const SizedBox(height: 4),
                        Text(
                          "Lat: ${h.lat.toStringAsFixed(5)}, "
                              "Lng: ${h.lng.toStringAsFixed(5)}",
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),

                    trailing: const Icon(Icons.location_on),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
