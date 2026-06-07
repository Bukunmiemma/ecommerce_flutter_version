import 'package:amazon_ui/common/widgets/custom_button.dart';
import 'package:amazon_ui/common/widgets/custom_textfield.dart';
import 'package:amazon_ui/common/widgets/show_snack_bar.dart';
import 'package:amazon_ui/features/auth/services/auth_service.dart';
import 'package:amazon_ui/state_management/auth_controller_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final AuthService authService = AuthService();

  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void handleSignup() async {
    //  FRONTEND VALIDATION FIRST
    if (!_formKey.currentState!.validate()) return;

    final success = await ref
        .read(authControllerProvider.notifier)
        .signup(
          nameController.text,
          emailController.text,
          passwordController.text,
        );

    if (!mounted) return;
    if (success) {
      Navigator.pushReplacementNamed(context, "/login");
    }
  }

  void handleGoogleLogin() async {
    final success = await ref
        .read(authControllerProvider.notifier)
        .signInWithGoogle();
    if (!mounted) return;

    if (success) {
      final authState = ref.read(authControllerProvider);
      Navigator.pushReplacementNamed(context, "/home");

      // if (authState.isAdmin) {
      //   Navigator.pushReplacementNamed(context, "/admin");
      // } else {
      //   Navigator.pushReplacementNamed(context, "/home");
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    ref.listen(authControllerProvider, (previous, next) {
      if (next.error != null && next.error != previous?.error) {
        showSnackBar(context, next.error!);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomTextfield(
                    controller: nameController,
                    isPassword: false,
                    hintText: "Name",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Name is required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),

                  CustomTextfield(
                    controller: emailController,
                    hintText: "Email",

                    isPassword: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Email is required";
                      }
                      if (!value.contains("@")) {
                        return "Enter a valid email";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  CustomTextfield(
                    controller: passwordController,
                    hintText: "Password",
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: authState.isSigningUp ? null : handleSignup,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 45),
                      backgroundColor: Colors.black,
                    ),
                    child: authState.isSigningUp
                        ? CircularProgressIndicator(strokeWidth: 2)
                        : const Text(
                            "Sign Up",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                  ),

                  //
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: authState.isGoogleLoading
                        ? null
                        : handleGoogleLogin,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 45),
                      backgroundColor: Colors.black,
                    ),
                    child: authState.isGoogleLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/google_icon.svg',
                                width: 20,
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Sign in with google',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 3),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(color: Colors.blue, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
