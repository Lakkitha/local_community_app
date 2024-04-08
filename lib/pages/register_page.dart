import 'package:flutter/material.dart';
import 'package:local_community_app/auth/auth_service.dart';
import 'package:local_community_app/Components/button.dart';
import 'package:local_community_app/Components/textfield.dart';

class RegisterPage extends StatefulWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _confrimpwController = TextEditingController();
  final void Function()? onTap;

  RegisterPage({super.key, this.onTap});

  //register method
  void register(BuildContext context) {
    final _auth = AuthService();

    //Check if password and confirm password are the same
    if (_pwController.text == _confrimpwController.text) {
      try {
        _auth.signUpWithEmailAndPassword(
          _emailController.text,
          _pwController.text,
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(e.toString()),
          ),
        );
      }
    }

    //If the passwords don't match -> fix it
    else {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: const Text("Passwords don't match"),
        ),
      );
    }
  }

  @override
  State<RegisterPage> createState() => _registerpageState();
}

class _registerpageState extends State<RegisterPage> {
  //TextControllers
  final TextEditingController usernamecontroller = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _pwController = TextEditingController();

  final TextEditingController confirmpasswordcontroller =
      TextEditingController();

  //register method
  void register() {
    //show progress
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person,
                size: 70,
                color: Color.fromARGB(255, 32, 50, 80),
              ),
              const SizedBox(height: 20),
              Text(
                "Local Community",
                style: TextStyle(fontSize: 20),
              ),

              const SizedBox(height: 50),
              //username
              textfield(
                  hintText: "Username",
                  obscureText: false,
                  controller: usernamecontroller),

              const SizedBox(height: 10),
              //Email
              textfield(
                  hintText: "Email",
                  obscureText: false,
                  controller: _emailController),

              const SizedBox(height: 10),
              //password
              textfield(
                  hintText: "Password",
                  obscureText: true,
                  controller: _pwController),

              const SizedBox(height: 10),
              //confirm password
              textfield(
                  hintText: "Confirm Password",
                  obscureText: true,
                  controller: confirmpasswordcontroller),

              const SizedBox(height: 10),

              //forgot password
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Forgot password?",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              //Register button
              button(
                text: "Register",
                onTap: register,
              ),

              const SizedBox(
                height: 25,
              ),

              //Already have an account text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?"),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text("Login",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
