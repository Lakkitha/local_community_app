import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../database/userdb.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final String? uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: null, // Remove the app bar
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 7, // Takes 70% of the height
                child: FutureBuilder<Map<String, dynamic>?>(
                  future: Database().getCurrentUserData(uid!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }
                    if (snapshot.data == null) {
                      return Center(
                        child: Text('No user data found'),
                      );
                    }

                    final username = snapshot.data!['username'] as String;
                    final email = snapshot.data!['email'] as String;
                    // You can add more user information fields here

                    // Dummy values for events count, followers, and followings
                    final eventsCount = 10;
                    final followersCount = 100;
                    final followingsCount = 50;

                    return Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/backgroundpropic.jpg'), // Set your background image here
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: DefaultTextStyle(
                            style: TextStyle(color: Colors.white, fontSize: 20), // Set default text color and size for the first section
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end, // Align content at the bottom
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '$username',
                                  style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold), // Increased font size and bold for username
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  '$email',
                                  style: TextStyle(fontSize: 20.0),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildStatistic('Events', eventsCount.toString()),
                                    _buildStatistic('Followers', followersCount.toString()),
                                    _buildStatistic('Followings', followingsCount.toString()),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildIconButton(Icons.person_add, 'Follow', () {
                                      // Implement follow functionality here
                                    }),
                                    _buildIconButton(Icons.message, 'Message', () {
                                      // Implement message functionality here
                                    }),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                flex: 3, // Takes 30% of the height
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'My Events',
                        style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold), // Increased font size for the title
                      ),
                      SizedBox(height: 10),
                      _buildEventCard(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white), // Make back button white
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Positioned(
            top: 40,
            right: 10,
            child: IconButton(
              icon: Icon(Icons.settings, color: Colors.white), // Make gear icon white
              onPressed: () {
                // Navigate to settings page or show settings dialog
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatistic(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white), // Make text white
          ),
          SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(fontSize: 16.0, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, String label, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        children: [
          Icon(
            icon,
            size: 30,
            color: Colors.blue,
          ),
          SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard() {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'My Event',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red), // Delete button icon
                  onPressed: () {
                    // Implement delete functionality here
                  },
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              'Start Date: 12/04/2024',
              style: TextStyle(fontSize: 16.0, color: Colors.grey),
            ),
            Text(
              'End Date: 20/04/2024',
              style: TextStyle(fontSize: 16.0, color: Colors.grey),
            ),
            SizedBox(height: 10),
            Text(
              'Description: This is a event that i posted shown on my profile.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 10)
          ],
        ),
      ),
    );
  }
}
