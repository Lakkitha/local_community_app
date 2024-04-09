import 'package:flutter/material.dart';
import '../util/styled_button.dart';
import '../util/styled_textfield.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo and Name
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo.png', // Replace 'assets/logo.png' with your actual logo path
                      height: 100,
                      width: 100,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Local Community', // Replace 'Your App Name' with your actual app name
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // Input Fields
                StyledTextField(
                  hintText: 'Enter your email',
                  labelText: 'Email',
                ),
                SizedBox(height: 10),
                StyledTextField(
                  hintText: 'Enter your password',
                  labelText: 'Password',
                  obscureText: true,
                ),
                SizedBox(height: 20),
                // Login Button
                StyledButton(
                  text: 'Login',
                  onPressed: () {
                    // Add your login functionality here
                  },
                ),
				SizedBox(height: 10),
                // Additional Text and Link Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Add navigation to the sign-up page
                      },
                      child: Text(
                        'Sign up',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}