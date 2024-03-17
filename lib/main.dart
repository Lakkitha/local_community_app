import 'package:flutter/material.dart';
import 'package:local_community_app/screens/signin_page.dart';

void main() async {
/*   WidgetsFlutterBinding.ensureInitialized();
  await firebase.initializeApp(); */
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Local Community',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SigninPage(),
    );
  }
}
