import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:local_community_app/screens/viewevent.dart';
import 'package:local_community_app/themes/light_mode.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'Event Viewer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: ViewEvent(
        eventName: "Something",
        eventDate: "01/01/2023",
        eventOrganizer:
            "Something ",
        eventImage: 'assets/images/img.jpg',
        numberOfFollowers: 23,
      ),
    );
  }
}
