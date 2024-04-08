import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:local_community_app/auth/auth_gate.dart';
import 'package:local_community_app/Themes/light_mode.dart';
import 'package:local_community_app/pages/event_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Local Community',
      theme: lightmode,
      home: EventPage(),
    );
  }
}
