import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'report_hazard_screen.dart';
import 'hazard_map_screen.dart';
import 'about_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String username = "";

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  // -------- LOAD USERNAME --------
  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    username = prefs.getString("registered_username") ?? "";
    setState(() {});
  }

  // -------- LOGOUT --------
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("is_logged_in", false);
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, "/login");
  }

  // -------- MENU CARD WIDGET --------
  Widget menuCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: color.withOpacity(0.15),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 18),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios, size: 18),
            ],
          ),
        ),
      ),
    );
  }

  // -------- UI --------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),

      // ---------------- APPBAR ----------------
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F3A5F),
        title: const Text("HazardHunter"),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AboutScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Logout"),
                  content: const Text("Are you sure you want to logout?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text("Logout"),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                logout();
              }
            },
          ),
        ],
      ),

      // ---------------- BODY ----------------
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome, $username 👋",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 25),

            // REPORT HAZARD
            menuCard(
              icon: Icons.report_problem,
              title: "Report Hazard",
              color: Colors.orange,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const ReportHazardScreen()),
                );
              },
            ),

            // VIEW MAP
            menuCard(
              icon: Icons.map,
              title: "Hazard Map",
              color: Colors.green,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const HazardMapScreen()),
                );
              },
            ),

            // ABOUT US
            menuCard(
              icon: Icons.info,
              title: "About Us",
              color: Colors.blue,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AboutScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
