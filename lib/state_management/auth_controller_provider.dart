import 'package:amazon_ui/controller/auth_controller.dart';
import 'package:amazon_ui/features/auth/services/google_auth_service.dart';
import 'package:amazon_ui/model/auth_state.dart';
import 'package:flutter_riverpod/legacy.dart';

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) => AuthController(ref, GoogleAuthService()),
);
