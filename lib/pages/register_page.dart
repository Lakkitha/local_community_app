import 'package:flutter/material.dart';
import 'package:local_community_app/auth/auth_service.dart';
import 'package:local_community_app/utilis/buttons.dart';
import 'package:local_community_app/utilis/textfields.dart';

class RegisterPage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //logo
            Icon(
              Icons.message,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),

            const SizedBox(height: 50),

            //welcome back massage
            Text(
              "Create An Account",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 25),
            //email input

            MyTextField(
              hintText: "Email Address",
              obscureText: false,
              controller: _emailController,
            ),

            const SizedBox(height: 15),

            //password input
            MyTextField(
              hintText: "Password",
              obscureText: true,
              controller: _pwController,
            ),

            const SizedBox(height: 15),

            //confirm password input

            MyTextField(
              hintText: "Confirm Password",
              obscureText: true,
              controller: _confrimpwController,
            ),

            const SizedBox(height: 15),
            //login button

            MyButtons(
              text: "Register",
              onTap: () => register(context),
            ),

            const SizedBox(height: 25),
            //register button

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already a member? ",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    "Login Nigger",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
