import 'package:amazon_ui/features/auth/services/auth_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Welcome to the Home Screen"),
          ElevatedButton(
            onPressed: () async {
              await authService.logout(context);
            },

            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 45),
              backgroundColor: Colors.black,
            ),

            child: Text("Logout", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
