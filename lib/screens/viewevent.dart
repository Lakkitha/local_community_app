import 'package:flutter/material.dart';

class ViewEvent extends StatefulWidget {
  final String eventName;
  final String eventDate;
  final String eventOrganizer;
  final String eventImage; // Path to the event image

  const ViewEvent({
    Key? key,
    required this.eventName,
    required this.eventDate,
    required this.eventOrganizer,
    required this.eventImage,
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
                  width: 2,
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
                          height: 200, // Adjust height as needed
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
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft:
                                Radius.circular(12), // Rounded bottom corners
                            bottomRight:
                                Radius.circular(12), // Rounded bottom corners
                          ),
                          color: Colors.black
                              .withOpacity(0.3), // Transparent black
                        ),
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Profile Picture
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        eventName,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        'Organizer: $eventOrganizer',
                                        style: TextStyle(
                                          fontSize: 16,
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
                                            fontSize: 16,
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
                                            fontSize: 16,
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
