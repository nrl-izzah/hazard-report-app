import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  final String githubUrl =
      "https://github.com/YOUR_USERNAME/YOUR_REPOSITORY";

  Future<void> openLink() async {
    final uri = Uri.parse(githubUrl);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw "Could not launch $githubUrl";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F3A5F),
        title: const Text("About HazardHunter"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // APP ICON
            const Center(
              child: Icon(
                Icons.warning_amber_rounded,
                size: 90,
                color: Color(0xFFF39C12),
              ),
            ),

            const SizedBox(height: 15),

            const Center(
              child: Text(
                "HazardHunter",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const Center(
              child: Text(
                "Community Hazard Reporting Application",
                style: TextStyle(color: Colors.grey),
              ),
            ),

            const SizedBox(height: 30),

            // -------- DEVELOPERS --------
            const Text(
              "Developers",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text("• Syazilah Iwani"),
            const Text("• Nurul 'Izzah Mat Rosdi"),
            const Text("• (Add third member name here)"),

            const SizedBox(height: 25),

            // -------- APP INFO --------
            const Text(
              "Application Information",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "HazardHunter allows users to report hazards such as fire, flood, and accidents in real time. "
                  "The reports are displayed on an interactive map to improve public awareness and safety.",
            ),

            const SizedBox(height: 25),

            // -------- GITHUB --------
            const Text(
              "Project Repository",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            GestureDetector(
              onTap: openLink,
              child: Text(
                githubUrl,
                style: const TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // -------- COPYRIGHT --------
            const Center(
              child: Text(
                "© 2026 HazardHunter Team\nAll rights reserved.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
