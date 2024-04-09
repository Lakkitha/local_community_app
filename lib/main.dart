import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:local_community_app/themes/light_mode.dart';

import 'Navigation/NavBar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NavBar(),
      debugShowCheckedModeBanner: false,
      title: 'Local Community',
      theme: LightMode,
    );
  }
}
