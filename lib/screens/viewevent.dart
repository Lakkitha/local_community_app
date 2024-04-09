import 'package:flutter/material.dart';

class ViewEvent extends StatefulWidget {
  final String eventName;
  final String eventDate;
  final String eventDescription;
  final String eventImage; // Path to the event image

  const ViewEvent({
    Key? key,
    required this.eventName,
    required this.eventDate,
    required this.eventDescription,
    required this.eventImage,
  }) : super(key: key);

  @override
  _ViewEventState createState() => _ViewEventState();
}

class _ViewEventState extends State<ViewEvent> {
  String newEventName = '';
  String newEventDate = '';
  String newEventDescription = '';
  String newEventImage = ''; // Path to the event image

  List<Map<String, String>> events = [
    {
      'eventName': "Something",
      'eventStartDate': "01/01/2023",
      'eventEndDate': "01/03/2023",
      'eventDescription':
          "Something Someiniddsijfdsif dsfdsfdfdsfdsfds f dsfdsf dfsd fdf sd fdsfdsf dsf dsfdsf dsfds dsf dsfdf dsf asdsa sd sad as dsa d sad as das d sad sa ds das d sad as das d sad as dsa dsa d",
      'eventImage': 'assets/images/img.jpg',
    },
    // Add more events here
  ];

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
            buildEventCard(
              eventName: event['eventName']!,
              eventStartDate: event['eventStartDate']!,
              eventEndDate: event['eventEndDate']!,
              eventDescription: event['eventDescription']!,
              eventImage: event['eventImage']!,
            ),
          SizedBox(height: 80), // Space for the add event button
        ],
      ),
    );
  }

  Widget buildEventCard({
    required String eventName,
    required String eventStartDate,
    required String eventEndDate,
    required String eventDescription,
    required String eventImage,
  }) {
    String truncatedDescription = truncateDescription(
        eventDescription, 25); // Truncate description if more than 25 words
    bool isTruncated = eventDescription != truncatedDescription;
    bool isPastEndDate = isEventPastEndDate(eventEndDate);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () {
          // Add onTap functionality if needed
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200], // Grey background color
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isPastEndDate ? Colors.red : Colors.grey[200]!,
              width: 2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        eventName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '$eventStartDate - $eventEndDate',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        truncatedDescription,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      if (isTruncated)
                        Row(
                          children: [
                            Icon(Icons.more_horiz,
                                color: Colors
                                    .grey), // Three dots icon in grey color
                          ],
                        ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      eventImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String truncateDescription(String description, int wordLimit) {
    List<String> words = description.split(' ');
    if (words.length > wordLimit) {
      return words.sublist(0, wordLimit).join(' ') + '';
    } else {
      return description;
    }
  }

  bool isEventPastEndDate(String endDateString) {
    try {
      // Convert end date string to DateTime object
      DateTime endDate = DateTime.parse(endDateString);
      // Get current date
      DateTime currentDate = DateTime.now();
      // Check if current date is after end date
      return currentDate.isAfter(endDate);
    } catch (e) {
      print('Error parsing end date: $e');
      return false; // Return false if there's an error parsing the date
    }
  }
}
