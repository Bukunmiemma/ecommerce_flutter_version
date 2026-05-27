import 'package:amazon_ui/features/auth/services/auth_service.dart';
import 'package:amazon_ui/features/auth/services/google_auth_service.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'package:amazon_ui/model/auth_state.dart';

class AuthController extends StateNotifier<AuthState> {
  final AuthService _authService;
  final GoogleAuthService _googleAuthService;

  AuthController(this._authService, this._googleAuthService)
    : super(AuthState.initial()) {
    checkAuth();
  }

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
    state = state.copyWith(isLoading: true, isSigningUp: true, error: null);
    try {
      final res = await _authService.signUp(name, email, password);
      if (res != null) {
        state = state.copyWith(
          user: res.user,
          isLoading: false,
          isSigningUp: false,
        );
        return true;
      }
      state = state.copyWith(
        isLoading: false,
        error: "Signup failed",
        isSigningUp: false,
      );
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: "Something went wrong");
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    state = state.copyWith(isGoogleLoading: true, error: null);

    try {
      final res = await _googleAuthService.signInWithGoogle();

      if (res != null) {
        state = state.copyWith(user: res.user, isGoogleLoading: false);
        return true;
      }

      state = state.copyWith(isLoading: false, error: "Google sign-in failed");
      return false;
    } catch (e) {
      state = state.copyWith(
        isGoogleLoading: false,
        error: "Something went wrong",
      );
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true);
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
}

//Future<bool> checkAuth() async {
    //   final token = await _authService.getToken();

    //   if (token == null) return false;

    //   try {
    //     // Optional: call backend /validate
    //     final user = await _authService.getCurrentUser(token);

    //     if (user != null) {
    //       state = state.copyWith(user: user);
    //       return true;
    //     }

    //     return false;
    //   } catch (e) {
    //     return false;
    //   }
    // }