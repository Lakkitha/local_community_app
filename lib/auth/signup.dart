import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../util/styled_button.dart';
import '../util/styled_textfield.dart';
import '../database/userdb.dart';
import 'validator.dart';
import 'firebase_auth_services.dart';

String? _email;
DateTime? _selectedDate;
String? _gender;
String? _username;
String? _password;
String? _confirmPassword;


class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center( // Wrap with Center widget to center the content vertically
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
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
              // Email Field
              StyledTextField(
                hintText: 'Enter your email',
                labelText: 'Email',
                onChanged: (value) {
                  setState(() {
                    _email = value;
                  });
                },
              ),
              SizedBox(height: 20),
              // Date of Birth Field
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Date of Birth',
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedDate != null
                            ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                            : 'Select Date',
                      ),
                      Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Gender Field
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Gender:',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: 10),
                  DropdownButton<String>(
                    hint: Text('Select Gender'),
                    value: _gender,
                    onChanged: (String? value) {
                      setState(() {
                        _gender = value;
                      });
                    },
                    items: <String>['Male', 'Female'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Next Page Button
              StyledButton(
                text: 'Next',
                verticalPadding: 10,
                onPressed: () async {
                  // Check if any field is empty or contains only whitespace
                  if (_email == null || _email!.trim().isEmpty ||
                      _selectedDate == null ||
                      _gender == null) 
                  {
                    StyledDialog.show(
                      context,
                      title: 'Missing Information',
                      content: 'Please fill in all fields before proceeding.',
                    );
                  } 
                  else if (!EmailValidator.isValid(_email!)) 
                  {
                    StyledDialog.show(
                      context,
                      title: 'Invalid Email',
                      content: 'Please enter a valid email address.',
                    );
                  }
                  else if (_selectedDate!.isAfter(DateTime.now().subtract(Duration(days: 13 * 365)))) 
                  {
                    StyledDialog.show(
                      context,
                      title: 'Invalid Age',
                      content: 'You must be at least 13 years old to sign up.',
                    );
                  }
                  else 
                  {
                    
                    // Check if the email is already taken before proceeding
                    bool emailExists = await EmailValidator.checkIfEmailExists(_email!);

                    if (emailExists) {
                      StyledDialog.show(
                        context,
                        title: 'Email Already Exists',
                        content: 'An account with this email already exists. Please use a different email address.',
                      );
                    } 
                    else 
                    {
                      // Navigate to the next page if email is not taken
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SecondScreen(
                          username: _username,
                          password: _password,
                          confirmPassword: _confirmPassword,
                        )),
                      );
                    }
                  }
                },
              ),
			        SizedBox(height: 10),
                // Additional Text and Link Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Have an account?",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    TextButton(
                      onPressed: () 
                      {
                        Navigator.pushNamed(context, "/login");
                      },
                      child: Text(
                        'Login',
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
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
}

class SecondScreen extends StatefulWidget {
  final String? username;
  final String? password;
  final String? confirmPassword;

  SecondScreen({Key? key, this.username, this.password, this.confirmPassword}) : super(key: key);


  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with provided values or empty strings
    _usernameController = TextEditingController(text: widget.username ?? '');
    _passwordController = TextEditingController(text: widget.password ?? '');
    _confirmPasswordController = TextEditingController(text: widget.confirmPassword ?? '');
  }

  final FireBaseAuthService _auth = FireBaseAuthService();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Previous'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 100.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo and Name
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: 100,
                    width: 100,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Local Community',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),
              // Password Field
              StyledTextField(
                hintText: 'Enter your username',
                labelText: 'Username',
                controller: _usernameController,
                onChanged: (value) {
                  _username = value;
                },
                verticalPadding: 18,
              ),

              SizedBox(height: 20),
              // Password Field
              StyledTextField(
                hintText: 'Enter your password',
                labelText: 'Password',
                controller: _passwordController,
                onChanged: (value) {
                  _password = value;
                },
                obscureText: true,
                verticalPadding: 18,
				
              ),
              SizedBox(height: 20),
              // Confirm Password Field
              StyledTextField(
                hintText: 'Confirm your password',
                labelText: 'Confirm Password',
                controller: _confirmPasswordController,
                onChanged: (value) {
                  _confirmPassword = value;
                },
                obscureText: true,
                verticalPadding: 18,
              ),

              SizedBox(height: 20),
              // Sign Up Button
              StyledButton(
                text: 'Sign Up',
                verticalPadding: 10,
                onPressed: () 
                {
                  _signUp();
                },
              ),

              SizedBox(height: 20),
              // Additional Text and Link Button
              Center(
                child: Text(
                  "By signing up, you agree to the terms and conditions",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _signUp() async 
  {
    if (_password != _confirmPassword) {
      StyledDialog.show(
        context,
        title: 'Password Mismatch',
        content: 'Password and Confirm Password must match.',
      );
      return;
    }

    if (_username == null ||
        _password == null ||
        _confirmPassword == null ||
        _username!.trim().isEmpty ||
        _password!.isEmpty ||
        _confirmPassword!.isEmpty) {
      StyledDialog.show(
        context,
        title: 'Missing Information',
        content: 'Please fill in all fields.',
      );
      return;
    }

    if (_username!.trim().length < 4 || _username!.trim().length > 15) 
    {
      StyledDialog.show(
        context,
        title: 'Invalid Username',
        content: 'Username must be between 4 and 15 characters long.',
      );
      return;
    }

    if (_password!.length < 4) 
    {
      StyledDialog.show(
        context,
        title: 'Invalid Password',
        content: 'Password must be at least 4 characters long.',
      );
    return;
    }

    if (!_password!.contains(RegExp(r'[A-Z]'))) 
    {
      StyledDialog.show(
        context,
        title: 'Invalid Password',
        content: 'Password must contain at least one capital letter.',
      );
      return;
    }

    if (!_password!.contains(RegExp(r'[0-9]'))) 
    {
      StyledDialog.show(
        context,
        title: 'Invalid Password',
        content: 'Password must contain at least one number.',
      );
      return;
    }

    try 
    {
      // Check if the username is already taken
      bool isUsernameTaken = await _isUsernameTaken(_username!);

      if (isUsernameTaken) 
      {
        StyledDialog.show(
          context,
          title: 'Username Taken',
          content: 'The username is already taken. Please choose another one.',
        );
        return;
      }

      User? user = await _auth.signUpWithEmailAndPassword(_email!, _password!);

      if (user != null) {
        print("User is successfully created");

        // Store additional user information in Firestore
        Database db = Database();
        await db.storeUserInfo(user.uid, _email!, _username!, _selectedDate!.toIso8601String(), _gender!);
        
        Navigator.pushNamed(context, "/home");
      }
    } 
    catch (e) 
    {
      print("Some error happened when creating account");
    }
  }

  Future<bool> _isUsernameTaken(String username) async 
  {
    try 
    {
      // Check if the username exists in the Firestore collection
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      // If there are documents with the provided username, it's taken
      return snapshot.docs.isNotEmpty;
    } 
    catch (e) {
      // Error occurred while checking username availability
      print('Error checking username availability: $e');
      return true; // Return true to prevent sign-up
    }
  }
}

