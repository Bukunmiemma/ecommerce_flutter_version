import 'dart:convert';

import 'package:amazon_ui/common/widgets/custom_textfield.dart';
import 'package:amazon_ui/common/widgets/show_snack_bar.dart';
import 'package:amazon_ui/features/auth/screens/login_screen.dart';
import 'package:amazon_ui/secrets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ResetPasswordScreen extends StatefulWidget {
  final String token;

  const ResetPasswordScreen({super.key, required this.token});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final passwordController = TextEditingController();
  bool loading = false;

  Future<void> resetPassword() async {
    final String baseUrl = ipAddress; // your IP

    final response = await http.post(
      Uri.parse("$baseUrl/auth/reset-password"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "token": widget.token,
        "newPassword": passwordController.text,
      }),
    );

    if (!mounted) return;
    if (response.statusCode == 200) {
      showSnackBar(context, "Password updated");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    } else {
      showSnackBar(context, "Rest Password Failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Reset Password",
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CustomTextfield(
              controller: passwordController,
              hintText: "New Password",
              isPassword: true,
              errorText: "Retry",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Password is required";
                }
                if (value.length < 6) {
                  return "Password must be at least 6 characters";
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            SizedBox(height: 20),

            loading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: resetPassword,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 45),
                      backgroundColor: Colors.black,
                    ),
                    child: const Text(
                      "Reset Password",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
