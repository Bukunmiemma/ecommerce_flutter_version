// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:amazon_ui/model/user.dart';

class AuthState {
  final bool isLoading;
  final User? user;
  final String? error;

  final bool isSigningUp;
  final bool isGoogleLoading;
  AuthState({
    required this.isLoading,
    this.user,
    this.error,
    required this.isSigningUp,
    required this.isGoogleLoading,
  });

  factory AuthState.initial() {
    return AuthState(
      isSigningUp: false,
      isGoogleLoading: false,
      isLoading: true,
      user: null,
      error: null,
    );
  }

  AuthState copyWith({
    bool? isLoading,
    User? user,
    String? error,
    bool? isSigningUp,
    bool? isGoogleLoading,
    bool clearError = false,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: clearError ? null : error ?? this.error,
      isSigningUp: isSigningUp ?? this.isSigningUp,

      isGoogleLoading: isGoogleLoading ?? this.isGoogleLoading,
    );
  }

  bool get isAuthenticated => user != null;
  bool get isAdmin {
    return user?.role == "ADMIN";
  }
}
