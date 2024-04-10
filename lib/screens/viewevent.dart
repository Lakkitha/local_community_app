import 'package:flutter/material.dart';

class ViewEvent extends StatefulWidget {
  final String eventName;
  final String eventDate;
  final String eventOrganizer;
  final String eventImage; // Path to the event image
  final int numberOfFollowers; // Number of followers

  const ViewEvent({
    Key? key,
    required this.eventName,
    required this.eventDate,
    required this.eventOrganizer,
    required this.eventImage,
    required this.numberOfFollowers,
  }) : super(key: key);

  @override
  _ViewEventState createState() => _ViewEventState();
}

class _ViewEventState extends State<ViewEvent> {
  String newEventName = '';
  String newEventDate = '';
  String newEventOrganizer = '';
  String newEventImage = ''; // Path to the event image

  List<Map<String, String>> events = [
    {
      'eventName': "Something",
      'eventStartDate': "01/01/2023",
      'eventEndDate': "01/03/2023",
      'eventOrganizer': "John Doe",
      'eventImage': 'assets/images/img.jpg',
      'numberOfFollowers': '100', // Example number of followers
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
              eventOrganizer: event['eventOrganizer']!,
              eventImage: event['eventImage']!,
              numberOfFollowers: int.parse(event['numberOfFollowers']!),
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
    required String eventOrganizer,
    required String eventImage,
    required int numberOfFollowers, // New parameter for number of followers
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Stack(
        children: [
          InkWell(
            onTap: () {
              // Add onTap functionality if needed
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12), // Rounded edges
                border: Border.all(
                  color: Colors.grey[200]!,
                  width: 1,
                ),
              ),
              child: ClipRRect(
                // ClipRRect to make it rounded
                borderRadius: BorderRadius.circular(18),
                child: Stack(
                  children: [
                    // Event Image
                    Stack(
                      children: [
                        Image.asset(
                          eventImage,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 300, // Adjust height as needed
                        ),
                        Positioned(
                          top: 8,
                          right: 8, // Moved to the top right
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                8), // Adjust the radius as needed
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 8,
                              ),
                              color: Color.fromARGB(255, 166, 166, 166)
                                  .withOpacity(0.5),
                              child: Text(
                                '📍Location',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Details Frame
                    Positioned(
                      top: 152, // Adjust the value to move the content up or down
                      left: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                          color: Colors.black.withOpacity(0.3),
                        ),
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Profile Picture
                                Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1.5,
                                    ),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(eventImage),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5),
                                // Event Title and Organizer
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        eventName,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Organizer: $eventOrganizer',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 16),
                                // Event Times
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.calendar_view_month_outlined,
                                            color: Colors.white),
                                        SizedBox(width: 4),
                                        Text(
                                          '$eventStartDate',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(Icons.calendar_view_month_outlined,
                                            color: Colors.white),
                                        SizedBox(width: 4),
                                        Text(
                                          '$eventEndDate',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    //Followers Frame
                    Positioned(
                      bottom: -5,
                      left: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                          color: Colors.white, // White background color
                        ),
                        padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0,
                            16.0), // Added padding to the bottom
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            /* Text(
                              'Followers',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ), */
                            Icon(Icons.person),
                            Text(
                              '$numberOfFollowers', // Display number of followers
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}