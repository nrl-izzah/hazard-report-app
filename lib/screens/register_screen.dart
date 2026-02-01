import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> register() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("username", usernameController.text);
    await prefs.setString("password", passwordController.text);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Registered successfully!")),
    );

    Navigator.pop(context); // Back to login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: "Username"),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),

            const SizedBox(height: 25),

            ElevatedButton(
              onPressed: register,
              child: const Text("Register"),
            ),

          ],
        ),
      ),
    );
  }
}
