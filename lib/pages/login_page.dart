import 'package:flutter/material.dart';
import 'package:local_community_app/auth/auth_service.dart';
import 'package:local_community_app/utilis/buttons.dart';
import 'package:local_community_app/utilis/textfields.dart';

class LoginPage extends StatelessWidget {
  //email and password text controller
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final void Function()? onTap;

  LoginPage({super.key, this.onTap});

  //login method
  void login(BuildContext context) async {
    //Auth service login method
    final authService = AuthService();

    //Try to login
    try {
      await authService.signInWithEmailAndPassword(
        _emailController.text,
        _pwController.text,
      );
    }
    //Catch any errors
    catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(e.toString()),
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
              "Welcome Back",
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
            //login button

            MyButtons(
              text: "Login Nigger",
              onTap: () => login(context),
            ),

            const SizedBox(height: 25),
            //register button

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Not a member?",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    "Register Now",
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
