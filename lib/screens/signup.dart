import 'package:flutter/material.dart';
import '../util/styled_button.dart';
import '../util/styled_textfield.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String? _email;
  DateTime? _selectedDate;
  String? _gender;

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
                text: 'Next Page',
                onPressed: () {
                  // Navigate to the next page to fill username, password, and confirm password
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SecondSignupPage()),
                  );
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
                      onPressed: () {
                        // Add navigation to the sign-up page
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

class SecondSignupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Previous'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 160.0),
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
                hintText: 'Enter your password',
                labelText: 'Password',
                obscureText: true,
                verticalPadding: 18,
              ),
              SizedBox(height: 20),
              // Confirm Password Field
              StyledTextField(
                hintText: 'Confirm your password',
                labelText: 'Confirm Password',
                obscureText: true,
                verticalPadding: 18,
              ),
              SizedBox(height: 20),
              // Sign Up Button
              StyledButton(
                text: 'Sign Up',
                onPressed: () {
                  // Add your sign up functionality here
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
}

