import 'dart:convert';
import 'package:amazon_ui/features/auth/screens/login_screen.dart';
import 'package:amazon_ui/model/auth_response.dart';
import 'package:amazon_ui/model/user.dart';
import 'package:amazon_ui/secrets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final _storage = const FlutterSecureStorage();
  final String baseUrl = ipAddress; // your IP

  Future<String?> getToken() async {
    return await _storage.read(key: "jwt");
  }

  Future<void> saveToken(String token) async {
    await _storage.write(key: "jwt", value: token);
  }

  Future<void> clearToken() async {
    await _storage.delete(key: "jwt");
  }

  // Optional: quick check if token still valid
  Future<bool> isAuthenticated() async {
    final token = await getToken();
    if (token == null) return false;

    final res = await http.get(
      Uri.parse("$baseUrl/auth/validate"),
      headers: {"Authorization": "Bearer $token"},
    );

    return res.statusCode == 200;
  }

  // sign up
  Future<AuthResponse?> signUp(
    String name,
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/auth/signup"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"name": name, "email": email, "password": password}),
      );

      final data = jsonDecode(response.body);
      final authResponse = AuthResponse.fromJson(data);
      // if (response.statusCode == 200 || response.statusCode == 201) {

      //   return authResponse;
      // }
      // print("Signup failed: ${response.body}");
      await saveToken(authResponse.token);

      return authResponse;
    } catch (e) {
      print("Signup error: $e");

      return null;
    }
  }

  Future<void> logout(BuildContext context) async {
    final token = await getToken();

    // Optional: notify backend
    await http.post(
      Uri.parse("$baseUrl/auth/logout"),
      headers: {"Authorization": "Bearer $token"},
    );

    await clearToken();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
      (route) => false,
    );
  }
  // void logout(BuildContext context) async {
  //   final authService = AuthService();

  //   final token = await authService.getToken();

  //   // Optional: tell backend to blacklist
  //   await http.post(
  //     Uri.parse("$baseUrl/auth/logout"),
  //     headers: {"Authorization": "Bearer $token"},
  //   );

  //   await authService.clearToken();

  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(builder: (_) => LoginScreen()),
  //   );
  // }

  Future<User?> getCurrentUser(String token) async {
    // final storage = FlutterSecureStorage();
    // final token = await storage.read(key: "jwt");

    try {
      final response = await http.get(
        Uri.parse("$baseUrl/auth/get-current-user"),
        headers: {"Authorization": "Bearer $token"},
      );

      print(response.body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        //  return User.fromMap(data);

        return User.fromMap({
          "id": data["id"].toString(),
          "email": data["email"],
          "name": data["name"],
          "role": data["role"], // mapping

          "token": token,
        });
      }
      return null;
    } catch (e) {
      print("getCurrentUser error: $e");
      return null;
    }
  }

  //Login
  Future<AuthResponse?> login(String email, String password) async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/auth/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        final authResponse = AuthResponse.fromJson(data);
        await saveToken(authResponse.token);

        return authResponse; //RETURN USER MODEL
      }
    } catch (e) {
      print(" Login error:$e");
    }
  }
}
