import 'package:flutter/material.dart';
import '../event/eventCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserEvent extends StatefulWidget {
  final String eventName;
  final String eventStartDate;
  final String eventEndDate;
  final String eventOrganizer;
  final String eventImage; // Path to the event image

  const UserEvent({
    Key? key,
    required this.eventName,
    required this.eventStartDate,
    required this.eventEndDate,
    required this.eventOrganizer,
    required this.eventImage,
  }) : super(key: key);

  @override
  _UserEventState createState() => _UserEventState();
}

class _UserEventState extends State<UserEvent> {
  late List<Map<String, String>> events;

  @override
  void initState() {
    super.initState();
    events = [
      {
        'eventName': widget.eventName,
        'eventStartDate': widget.eventStartDate,
        'eventEndDate': widget.eventEndDate,
        'eventOrganizer': widget.eventOrganizer,
        'eventImage': widget.eventImage,
      },
      // Add more events here
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        title: Text(
          widget.eventName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: buildEventCards(),
      ),
    );
  }

  Widget buildEventCards() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          for (var event in events)
            EventCard(
              eventName: event['eventName']!,
              eventStartDate: event['eventStartDate']!,
              eventEndDate: event['eventEndDate']!,
              eventOrganizer: event['eventOrganizer']!,
              eventImage: event['eventImage']!,
              eventLocation: event['eventLocation']!,
              eventDetails: event['eventDetails']!,
            ),
          SizedBox(height: 80), // Space for the add event button
        ],
      ),
    );
  }
}