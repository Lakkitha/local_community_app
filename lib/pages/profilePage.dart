import 'package:flutter/material.dart';
import 'package:local_community_app/Pages/UserEvents.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Profile Page'),
          ElevatedButton(
            onPressed: () {
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
            child: const Text('Go to User Event'),
          ),
        ],
      ),
    );
  }
}