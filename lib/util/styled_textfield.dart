import 'package:flutter/material.dart';

class StyledTextField extends StatelessWidget {
  final String hintText;
  final String labelText;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller; // New controller parameter
  final double? verticalPadding;
  final double? horizontalPadding;

  const StyledTextField({
    Key? key,
    required this.hintText,
    required this.labelText,
    this.obscureText = false,
    this.onChanged,
    this.controller, // Initialize the controller parameter
    this.verticalPadding,
    this.horizontalPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      onChanged: onChanged,
      controller: controller, // Set the controller property
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: verticalPadding ?? 20,
          horizontal: horizontalPadding ?? 12,
        ),
        hintStyle: TextStyle(
          color: Colors.grey,
          fontStyle: FontStyle.italic,
        ),
        labelStyle: TextStyle(
          color: Colors.grey,
        ),
      ),
    );
  }
}
