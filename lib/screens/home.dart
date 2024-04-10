import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../util/styled_button.dart'; // Assuming the path to the StyledButton class is correct
import 'package:cloud_firestore/cloud_firestore.dart';

import '../database/userdb.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String? uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>?>(
        future: Database().getCurrentUserData(uid!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Show a loading indicator while data is being fetched
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
              ],
            ),
          );
        },
      ),
    );
  }
}
