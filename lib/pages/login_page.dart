import 'package:flutter/material.dart';
import 'package:local_community_app/auth/auth_service.dart';
import 'package:local_community_app/Components/button.dart';
import 'package:local_community_app/Components/textfield.dart';
import 'package:local_community_app/pages/home_page.dart';

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
              //email
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

              //Login button
              button(
                text: "Login",
                onTap: () => login(context),
              ),

              const SizedBox(
                height: 25,
              ),

              //don't have an account text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?"),
                  GestureDetector(
                    onTap: onTap,
                    child: const Text("Register Now",
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
