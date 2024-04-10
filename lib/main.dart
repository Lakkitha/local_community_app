import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'auth/login.dart';
import 'auth/signup.dart';
import 'screens/home.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Local Community', // Replace 'Your App Title' with your actual app title
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthenticationWrapper(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/home': (context) => HomePage(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        // Add more named routes here if needed
      },
    );
  }
}

/// Class to remember the user
class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Placeholder for loading state
        } else if (snapshot.hasData) {
          return HomePage(); // Navigate to home page if user is logged in
        } else {
          return LoginPage(); // Navigate to login page if user is not logged in
        }
      },
    );
  }
}
