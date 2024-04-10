import 'package:flutter/material.dart';
import 'package:local_community_app/Pages/UserEvents.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../util/styled_button.dart';
import '../database/userdb.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final String? uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>?>(
        future: Database().getCurrentUserData(uid!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center( // Wrap CircularProgressIndicator with Center widget
              child: CircularProgressIndicator(), // Show a loading indicator while data is being fetched
            );
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.data == null) {
            return Text('No user data found'); // Handle case where user data does not exist
          }

          final username = snapshot.data!['username'] as String;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome $username buddy',
                  style: TextStyle(fontSize: 22.0),
                ),
                SizedBox(height: 15),
                StyledButton(
                  text: 'Sign Out',
                  verticalPadding: 10,
                  horizontalPadding: 20,
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushNamed(context, "/login");
                  },
                ),
                SizedBox(height: 15),
                StyledButton(
                  text: 'My events',
                  verticalPadding: 10,
                  horizontalPadding: 20,
                  onPressed: () 
                  {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserEvent(
                          eventName: "Something",
                          eventStartDate: "01/01/2069",
                          eventEndDate: "02/01/2049",
                          eventOrganizer: "Something",
                          eventImage: 'assets/images/img.jpg',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}