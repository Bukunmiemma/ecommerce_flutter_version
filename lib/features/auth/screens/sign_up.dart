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

  Map<String, String> errors = {};
  bool loading = false;

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
    print(errors["general"]);

    if (!mounted) return;
    if (success) {
      Navigator.pushReplacementNamed(context, "/login");
    } else {
      setState(() {
        errors["general"] = 'Sign up failed';
      });
    }
  }

  void handleGoogleLogin() async {
    final success = await ref
        .read(authControllerProvider.notifier)
        .signInWithGoogle();
    print(errors["general"]);
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
                    errorText: errors["name"],
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
                    errorText: errors["email"],
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

                    errorText: errors["password"],
                    validator: (value) {
                      if (value == null || value.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  if (errors["general"] != null)
                    showSnackBar(context, errors["general"].toString()),

                  const SizedBox(height: 10),

                  authState.isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: authState.isSigningUp
                              ? null
                              : handleSignup,
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 45),
                            backgroundColor: Colors.black,
                          ),
                          child: authState.isSigningUp
                              ? CircularProgressIndicator(strokeWidth: 2)
                              : const Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                        ),

                  //
                  const SizedBox(height: 30),

                  if (errors["general"] != null)
                    showSnackBar(context, errors["general"].toString()),

                  authState.isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: authState.isSigningUp
                              ? null
                              : handleGoogleLogin,
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 45),
                            backgroundColor: Colors.black,
                          ),
                          child: authState.isSigningUp
                              ? CircularProgressIndicator(strokeWidth: 2)
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

                          //  Row(
                          //   children: [
                          //   ],
                          // ),
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
