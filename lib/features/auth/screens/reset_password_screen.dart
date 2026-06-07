import 'package:amazon_ui/common/widgets/custom_textfield.dart';
import 'package:amazon_ui/features/auth/screens/login_screen.dart';
import 'package:amazon_ui/state_management/auth_controller_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  final String email;

  const ResetPasswordScreen({super.key, required this.email});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  void resetPassword() async {
    final success = await ref
        .read(authControllerProvider.notifier)
        .resetPassword(widget.email, passwordController.text.trim());

    if (!mounted) return;

    if (success && passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password reset successful")),
      );

      Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen()));
    } else {
      final error = ref.read(authControllerProvider).error;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error ?? "Reset failed")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Reset Password",
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Reset password for ${widget.email}"),

            const SizedBox(height: 20),

            CustomTextfield(
              controller: passwordController,
              hintText: "New Password",
              isPassword: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Password is required";
                }
                // if (value.length < 6) {
                //   return "Password must be at least 6 characters";
                // }
                return null;
              },
            ),

            const SizedBox(height: 20),

            CustomTextfield(
              controller: confirmPasswordController,
              hintText: "New Password",
              isPassword: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Password is required";
                }
                // if (value.length < 6) {
                //   return "Password must be at least 6 characters";
                // }
                return null;
              },
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: resetPassword,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 45),
                backgroundColor: Colors.black,
              ),
              child: authState.isLoading
                  ? CircularProgressIndicator()
                  : const Text(
                      "Reset Password",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
