import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/hazard.dart';

class HazardApi {

  // ⚠️ Change to YOUR PC IP
  static const String baseUrl = "http://192.168.1.110/hazard_server";

  // ============================
  // ADD hazard (POST)
  // ============================
  static Future<void> sendHazard(Hazard hazard) async {
    final response = await http.post(
      Uri.parse("$baseUrl/add_hazard.php"),
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
      },
      body: jsonEncode({
        "id": hazard.id.toString(),   // important as STRING
        "title": hazard.title,
        "description": hazard.description,
        "lat": hazard.lat,
        "lng": hazard.lng,
        "time": hazard.reportedAt.toIso8601String(),
      }),
    );

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception("Failed to save hazard");
    }
  }

  // ============================
  // GET hazards
  // ============================
  static Future<List<Hazard>> fetchHazards() async {
    final response =
    await http.get(Uri.parse("$baseUrl/get_hazards.php"));

    final List data = jsonDecode(response.body);

    return data.map((item) {
      return Hazard(
        id: int.tryParse(item["id"].toString()) ?? 0,
        title: item["title"] ?? "",
        description: item["description"] ?? "",
        lat: double.parse(item["lat"].toString()),
        lng: double.parse(item["lng"].toString()),
        reportedAt: DateTime.parse(item["time"]),
      );
    }).toList();
  }
}
