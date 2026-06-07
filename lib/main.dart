import 'package:amazon_ui/constants/global_variables.dart';

import 'package:amazon_ui/features/auth/screens/forgot_password_screen.dart';
import 'package:amazon_ui/features/auth/screens/home_screen.dart';
import 'package:amazon_ui/features/auth/screens/login_screen.dart';
import 'package:amazon_ui/features/auth/screens/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Amazon UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: GlobalVariables.backgroundColor,
        colorScheme: ColorScheme.light(primary: GlobalVariables.secondaryColor),
        appBarTheme: AppBarTheme(
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),

      initialRoute: '/',
      routes: {
        '/': (context) => SignUpScreen(),
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),

        '/forgot-password': (context) => ForgotPasswordScreen(),
      },
    );
  }
}
