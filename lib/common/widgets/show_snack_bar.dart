import 'package:flutter/material.dart';

void showSnackBar(
  BuildContext context,
  String message, {
  Color backgroundColor = const Color(0xFF1E1E1E),
}) {
  ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: backgroundColor,
        elevation: 8,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        duration: const Duration(seconds: 3),
      ),
    );
}
