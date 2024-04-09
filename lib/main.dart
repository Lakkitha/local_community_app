import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'screens/login.dart';
import 'screens/signup.dart';

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
      home: SignupPage(), // Set LoginPage as the home screen
      debugShowCheckedModeBanner: false,
    );
  }
}
