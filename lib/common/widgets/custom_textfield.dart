// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CustomTextfield extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String? errorText;
  final String? Function(String?)? validator;
  final bool isPassword;
  const CustomTextfield({
    super.key,
    required this.controller,
    required this.hintText,
    required this.errorText,
    required this.validator,
    required this.isPassword,
  });

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  bool _obscureText = false;
  bool _hasText = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword ? _obscureText : false,
      validator: widget.validator,
      onChanged: (value) {
        setState(() {
          _hasText = value.isNotEmpty;
        });
      },
      decoration: InputDecoration(
        hintText: widget.hintText,
        errorText: widget.errorText,

        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black38),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black38),
        ),
        suffixIcon: widget.isPassword && _hasText
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                ),

                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
      ),
    );
  }
}
