// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:amazon_ui/model/user.dart';

class AuthResponse {
  final String token;
  final User user;

  AuthResponse({required this.token, required this.user});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    final userMap = json["userResponse"];

    return AuthResponse(
      token: json["accessToken"],
      user: User.fromMap({
        "id": userMap["id"].toString(),
        "email": userMap["email"],
        "name": userMap["name"],
        "role": userMap["role"],

        "token": json["accessToken"],
      }),
    );
  }
}
