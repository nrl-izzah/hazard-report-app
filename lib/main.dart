import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/report_hazard_screen.dart';
import 'screens/hazard_map_screen.dart';
import 'screens/about_screen.dart';
import 'screens/signup_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('is_logged_in') ?? false;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HazardHunter',
      debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xFF1F3A5F),
          scaffoldBackgroundColor: const Color(0xFFF4F6F8),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1F3A5F),
            foregroundColor: Colors.white,
          ),
        ),

      home: isLoggedIn ? const HomeScreen() : const LoginScreen(),

      routes: {
        '/login': (_) => const LoginScreen(),
        '/signup': (_) => const SignupPage(),
        '/home': (_) => const HomeScreen(),
        '/report': (_) => const ReportHazardScreen(),
        '/map': (_) => const HazardMapScreen(),
        '/about': (_) => const AboutScreen(),
      },
    );
  }
}
