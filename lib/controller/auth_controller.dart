import 'package:amazon_ui/features/auth/services/auth_service.dart';
import 'package:amazon_ui/features/auth/services/google_auth_service.dart';
import 'package:amazon_ui/state_management/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'package:amazon_ui/model/auth_state.dart';

// final authService = ref.read(authServiceProvider);

class AuthController extends StateNotifier<AuthState> {
  final Ref ref;
  final GoogleAuthService _googleAuthService;

  AuthController(this.ref, this._googleAuthService)
    : super(AuthState.initial()) {
    checkAuth();
  }
  AuthService get _authService => ref.read(authServiceProvider);

  Future<void> checkAuth() async {
    state = state.copyWith(isLoading: true);
    final token = await _authService.getToken();
    if (token == null) {
      state = state.copyWith(isLoading: false, user: null);
      return;
    }
    final user = await _authService.getCurrentUser(token);
    state = state.copyWith(user: user, isLoading: false);
  }

  Future<bool> signup(String name, String email, String password) async {
    state = state.copyWith(isSigningUp: true, clearError: true);
    try {
      final res = await _authService.signUp(name, email, password);
      if (res != null) {
        state = state.copyWith(user: res.user, isSigningUp: false);
        return true;
      }
      state = state.copyWith(error: "Signup failed", isSigningUp: false);
      return false;
    } catch (e) {
      state = state.copyWith(isSigningUp: false, error: "Something went wrong");
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    state = state.copyWith(isGoogleLoading: true, clearError: true);

    try {
      final res = await _googleAuthService.signInWithGoogle();

      if (res != null) {
        state = state.copyWith(user: res.user, isGoogleLoading: false);
        return true;
      }

      state = state.copyWith(
        isGoogleLoading: false,
        error: "Google sign-in failed",
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isGoogleLoading: false,
        error: "Google sign in failed",
      );
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final res = await _authService.login(email, password);
      if (res != null) {
        state = state.copyWith(user: res.user, isLoading: false);
        return true;
      }
      state = state.copyWith(isLoading: false, error: "Login failed");
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: "Something went wrong");
      return false;
    }
  }

  //forgot password
  Future<bool> forgotPassword(String email) async {
    state = state.copyWith(isLoading: true, error: null);

    final response = await _authService.forgotPassword(email);

    state = state.copyWith(isLoading: false);

    if (response["success"]) {
      return true;
    } else {
      state = state.copyWith(error: response["message"]);
      return false;
    }
  }

  // VERIFY OTP

  Future<bool> verifyOtp(String email, String otp) async {
    state = state.copyWith(isLoading: true, error: null);

    final response = await _authService.verifyOtp(email, otp);

    state = state.copyWith(isLoading: false);

    if (response["success"]) {
      return true;
    } else {
      state = state.copyWith(error: response["message"]);

      return false;
    }
  }

  // RESET PASSWORD

  Future<bool> resetPassword(String email, String newpassword, String confirmPassword) async {
    state = state.copyWith(isLoading: true, error: null);

    final response = await _authService.resetPassword(email, newpassword, confirmPassword);

    state = state.copyWith(isLoading: false);

    if (response["success"]) {
      return true;
    } else {
      state = state.copyWith(error: response["message"]);

      return false;
    }
  }
}
