import 'package:amazon_ui/common/widgets/custom_textfield.dart';
import 'package:amazon_ui/common/widgets/show_snack_bar.dart';
import 'package:amazon_ui/features/auth/services/auth_service.dart';
import 'package:amazon_ui/state_management/auth_controller_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  // final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // final AppLinks _appLinks = AppLinks();

  // StreamSubscription? _sub;
  // bool _handled = false;
  // @override
  // void initState() {
  //   super.initState();
  //   initDeepLinks();
  // }

  // Future<void> initDeepLinks() async {
  //   try {
  //     final uri = await _appLinks.getInitialLink();

  //     if (uri != null) {
  //       handleUri(uri);
  //     }

  //     // background / running app
  //     _sub = _appLinks.uriLinkStream.listen((uri) {
  //       if (uri != null) {
  //         handleUri(uri);
  //       }
  //     });
  //   } catch (e) {
  //     print("Deep link error: $e");
  //   }
  // }

  // void handleUri(Uri uri) {
  //   if (_handled) return;
  //   _handled = true;
  //   if (uri.host == "reset-password") {
  //     final token = uri.queryParameters['token'];

  //     if (token != null) {
  //       navigatorKey.currentState?.push(
  //         MaterialPageRoute(builder: (_) => ResetPasswordScreen(token: token)),
  //       );
  //     }
  //   }
  // }

  // @override
  // void dispose() {
  //   _sub?.cancel();
  //   super.dispose();
  // }

  final AuthService authService = AuthService();

  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Map<String, String> errors = {};
  bool loading = false;

  void handleLogin() async {
    //  FRONTEND VALIDATION FIRST
    if (!_formKey.currentState!.validate()) return;

    final success = await ref
        .read(authControllerProvider.notifier)
        .login(emailController.text, passwordController.text);

    if (!mounted) return;
    if (success) {
      Navigator.pushReplacementNamed(context, "/home");
    } else {
      setState(() {
        errors["general"] = 'login failed';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Login",
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
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

              // const SizedBox(height: 30),
              // if (authState.error != null)
              //   showSnackBar(context, authState.error.toString()),
              authState.isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: handleLogin,
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 45),
                        backgroundColor: Colors.black,
                      ),
                      child: Text(
                        "Login",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
              // CustomButton(text: 'Login', onTap: ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/forgot-password");
                    },
                    child: const Text(
                      "Forgot Password ?",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
