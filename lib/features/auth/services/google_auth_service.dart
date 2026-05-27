import 'dart:convert';
import 'package:amazon_ui/model/auth_response.dart';
import 'package:amazon_ui/secrets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  final FlutterSecureStorage storage = FlutterSecureStorage();
  final String baseUrl = ipAddress; // your IP

  Future<AuthResponse?> signInWithGoogle() async {
    try {
      await _googleSignIn.initialize(serverClientId: webClientId);
      final GoogleSignInAccount? user = await _googleSignIn.authenticate();
      if (user == null) return null;
      final GoogleSignInAuthentication auth = await user.authentication;
      final String? idToken = auth.idToken;
      if (idToken == null) {
        print("ID Token is null");
        return null;
      }
      print("id token : $idToken");

      final response = await http.post(
        Uri.parse("$baseUrl/auth/google"),
        headers: {'Content-Type': 'application/json'},

        body: jsonEncode({'idToken': idToken}),
      );
      print("RAW RESPONSE: ${response.body}");

      if (response.body.isEmpty) return null;
      final data = jsonDecode(response.body);
      if (data == null || data is! Map<String, dynamic>) return null;

      final token = data["accessToken"];
      final userMap = data["userResponse"];

      if (token == null || userMap == null) {
        print("Token or user is null joooor");
        return null;
      }

      if (response.statusCode != 200) {
        print('Login failed ${response.body}');
        return null;
      }
      final authResponse = AuthResponse.fromJson(data);

      await storage.write(key: "jwt", value: authResponse.token);

      return authResponse;
      // return User.fromMap({
      //   "id": userMap["id"].toString(),
      //   "email": userMap["email"],
      //   "name": userMap["name"],
      //   "role": userMap["role"], //  IMPORTANT mapping
      //   "token": token,
      // });
    } catch (e) {
      print("Login Failed: $e");
      return null;
    }
  }

  // Future<void> saveToken(String token) async {
  //   await storage.write(key: "jwt", value: token);
  // }
}
