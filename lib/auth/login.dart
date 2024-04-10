import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../util/styled_button.dart';
import '../util/styled_textfield.dart';
import 'firebase_auth_services.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? _email;
  String? _password;
  
  final FireBaseAuthService _auth = FireBaseAuthService();

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
                  onChanged: (value) {
                    setState(() {
                      _email = value;
                    });
                  },
                ),
                SizedBox(height: 10),
                StyledTextField(
                  hintText: 'Enter your password',
                  labelText: 'Password',
                  obscureText: true,
                  onChanged: (value) {
                    setState(() {
                      _password = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                // Login Button
                StyledButton(
                  text: 'Login',
                  verticalPadding: 10,
                  onPressed: () {
                    _signIn();
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
                      onPressed: () 
					            {
                        Navigator.pushNamed(context, "/signup");
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

  void _signIn() async
  {
    print("Signing up");
    String email = _email ?? (throw ArgumentError('Email cannot be null'));
    String password = _password ?? (throw ArgumentError('Password cannot be null'));

    try 
    {
      User? user = await _auth.signInWithEmailAndPassword(email, password);

      if (user != null)
      {
        print("User is successfully signed in");
        Navigator.pushNamed(context, "/home");
      }
    }
    catch (e)
    {
      print("Some error happened when creating account");
    }
  }
}