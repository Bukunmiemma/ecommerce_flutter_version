import 'dart:convert';

import 'package:amazon_ui/common/widgets/custom_textfield.dart';
import 'package:amazon_ui/secrets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final baseUrl = ipAddress;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  Map<String, String> errors = {};

  Future<void> sendResetLink() async {
    if (!_formKey.currentState!.validate()) return;

    final response = await http.post(
      Uri.parse("$baseUrl/auth/forgot-password"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": emailController.text}),
    );

    if (response.statusCode == 200) {
      print("Reset email sent");
    } else {
      print("Failed");
    }
    print("Send reset email to ${emailController.text}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Forgot Password ",
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomTextfield(
                  controller: emailController,
                  isPassword: false,
                  hintText: "Email",
                  errorText: errors["password"],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email is required";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () {
                    sendResetLink();
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 45),
                    backgroundColor: Colors.black,
                  ),
                  child: Text(
                    "Send Reset Link",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
