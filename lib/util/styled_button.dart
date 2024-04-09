import 'package:flutter/material.dart';

/// A util class for a consistent styled button that is used for the login/register
/// 
class StyledButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const StyledButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue), // Background color
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Text color
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.symmetric(vertical: 15, horizontal: 30), // Button padding
        ),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3), // Button border radius
          ),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18, // Text size
        ),
      ),
    );
  }
}
