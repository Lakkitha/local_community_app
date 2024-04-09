import 'package:flutter/material.dart';

class StyledTextField extends StatelessWidget {
  final String hintText;
  final String labelText;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final double? verticalPadding; // New optional parameter for vertical padding
  final double? horizontalPadding; // New optional parameter for horizontal padding

  const StyledTextField({
    Key? key,
    required this.hintText,
    required this.labelText,
    this.obscureText = false,
	this.onChanged,
	this.verticalPadding,
    this.horizontalPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
	  onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4), // Adjust the border radius to make the text box slimmer
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue), // Change the border color when focused
        ),
		contentPadding: EdgeInsets.symmetric(
          vertical: verticalPadding ?? 20, // Use the provided value or default to 20
          horizontal: horizontalPadding ?? 12, // Use the provided value or default to 12
        ),
        hintStyle: TextStyle(
          color: Colors.grey, // Change the hint text color
          fontStyle: FontStyle.italic, // Optionally, change the font style
        ),
		labelStyle: TextStyle(
          color: Colors.grey, // Change the hint text color
        ),
      ),
    );
  }
}
