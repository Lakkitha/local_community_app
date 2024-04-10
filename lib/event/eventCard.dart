import 'package:flutter/material.dart';

import '../pages/EventDetails.dart';

class EventCard extends StatelessWidget {
  final String eventName;
  final String eventStartDate;
  final String eventEndDate;
  final String eventOrganizer;
  final String eventImage;

  const EventCard({
    Key? key,
    required this.eventName,
    required this.eventStartDate,
    required this.eventEndDate,
    required this.eventOrganizer,
    required this.eventImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Stack(
        children: [
          InkWell(
            onTap: () {
              //Redirect to Event Details
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventDetails(),
                ),
              );
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