import 'package:amazon_ui/features/auth/screens/home_screen.dart';
import 'package:amazon_ui/features/auth/screens/login_screen.dart';
import 'package:amazon_ui/features/auth/screens/sign_up.dart';
import 'package:amazon_ui/state_management/auth_controller_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    if (authState.isLoading) {
      return Scaffold(body: CircularProgressIndicator.adaptive());
    }
    if (authState.user != null) {
      return const HomeScreen();
    }
    return const SignUpScreen();
  }
}
