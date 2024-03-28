import 'package:flutter/material.dart';
import 'package:local_community_app/utilis/drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

/*   void logout() {
    final _auth = AuthService();
    _auth.signOut();
  } */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        actions: [
          //logout button
          /* IconButton(
            onPressed: logout,
            icon: Icon(Icons.logout),
          ), */
          //Make one for user
        ],
      ),
      drawer: MyDrawer(),
    );
  }
}
