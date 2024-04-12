import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:local_community_app/location/eventLocation.dart';

import '../pages/eventDetails.dart';

class EventCard extends StatefulWidget {
  final String userId;
  final String eventId;
  final String eventName;
  final String eventStartDate;
  final String eventEndDate;
  final String eventOrganizer;
  final String eventImage;
  final String eventLocation;
  final String eventDetails;

  const EventCard({
    Key? key,
    required this.userId,
    required this.eventId,
    required this.eventName,
    required this.eventStartDate,
    required this.eventEndDate,
    required this.eventOrganizer,
    required this.eventImage,
    required this.eventLocation,
    required this.eventDetails,
  }) : super(key: key);

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  String address = '';

  @override
  void initState() 
  {
    super.initState();
    fetchAddress();
  }

  Future<void> fetchAddress() async {
    GeoPoint geoPoint = EventLocation.convertStringToGeoPoint(widget.eventLocation);
    String? result = await EventLocation.getEventStreet(context, geoPoint.latitude, geoPoint.longitude);
    setState(() {
      address = result ?? '';
    });
  }

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
                  builder: (context) => EventDetails(
                    userid: widget.userId,
                    eventId: widget.eventId,
                    eventName: widget.eventName,
                    eventStartDate: widget.eventStartDate,
                    eventEndDate: widget.eventEndDate,
                    eventOrganizer: widget.eventOrganizer,
                    eventImage: widget.eventImage,
                    eventLocation: widget.eventLocation,
                    eventDetails: widget.eventDetails,
                  ),
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
                        Image.network(
                          widget.eventImage,
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
                                address,
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
                                      image: NetworkImage(widget.eventImage),
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
                                        widget.eventName,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        'Organizer: ${widget.eventOrganizer}',
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
                                          '${widget.eventStartDate}',
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
                                          '${widget.eventEndDate}',
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
