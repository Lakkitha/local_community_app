import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:local_community_app/database/eventsdb.dart';
import 'package:local_community_app/pages/settings_page.dart';
import '../database/userdb.dart';
import '../event/eventCard.dart';

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
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.7, // Set 70% of screen height
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/backgroundpropic.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: DefaultTextStyle(
                        style: TextStyle(color: Colors.white, fontSize: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            FutureBuilder<Map<String, dynamic>?>(
                              future: Database().getCurrentUserData(uid!),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                }
                                if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                }
                                if (snapshot.data == null) {
                                  return Text('No user data found');
                                }

                                final username = snapshot.data!['username'] as String;
                                final email = snapshot.data!['email'] as String;
                                // You can add more user information fields here

                                // Dummy values for events count, followers, and followings
                                final eventsCount = 10;
                                final followersCount = 100;
                                final followingsCount = 50;

                                return Column(
                                  children: [
                                    Text(
                                      '$username',
                                      style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
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
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'My Events',
                        style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      FutureBuilder<List<Map<String, dynamic>>>(
                        future: EventsDatabase().getUserEvents(uid!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }
                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Text('No events found');
                          }

                          return Column(
                            children: snapshot.data!.map((eventData) {
                              return EventCard(
                                eventName: eventData['event_name'],
                                eventStartDate: eventData['start_date'],
                                eventEndDate: eventData['end_date'],
                                eventOrganizer: 'Me', // Assuming the user is the organizer
                                eventImage: eventData['event_image'],
                                eventLocation: eventData['event_location'],
                                eventDetails: eventData['event_description'],
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 40,
            right: 10,
            child: IconButton(
              icon: Icon(Icons.settings, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildStatistic(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white),
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
