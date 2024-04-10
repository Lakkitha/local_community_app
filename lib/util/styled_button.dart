import 'package:flutter/material.dart';

/// A util class for a consistent styled button that is used for the login/register
/// 
class StyledButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? verticalPadding; // New optional parameter for vertical padding
  final double? horizontalPadding; // New optional parameter for horizontal padding

  const StyledButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.verticalPadding,
    this.horizontalPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue), // Background color
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Text color
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.symmetric(
            vertical: verticalPadding ?? 15, // Use the provided value or default to 20
            horizontal: horizontalPadding ?? 30, // Use the provided value or default to 12
            ), // Button padding
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

class StyledDialog {
  static void show(BuildContext context,
      {String? title, String? content, String okText = 'OK'}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: title != null ? Text(title) : null,
          content: content != null ? Text(content) : null,
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                okText,
                style: TextStyle(color: Colors.blue), // OK button text color
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Dialog border radius
          ),
        );
      },
    );
  }
}
