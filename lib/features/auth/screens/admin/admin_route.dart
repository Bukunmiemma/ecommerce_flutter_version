import 'package:amazon_ui/features/auth/screens/login_screen.dart';
import 'package:amazon_ui/state_management/auth_controller_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminRoute extends ConsumerWidget {
  final Widget child;
  const AdminRoute({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    if (authState.user == null) {
      return const LoginScreen();
    }
    if (!authState.isAdmin) {
      return Scaffold(body: Center(child: Text("Access Denied")));
    }

    return child;
  }
}
