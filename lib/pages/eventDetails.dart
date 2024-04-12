import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:local_community_app/database/eventsdb.dart';
import 'package:local_community_app/location/eventLocation.dart';
import 'package:local_community_app/util/styled_button.dart';

class EventDetails extends StatefulWidget {
  final String userid;
  final String eventId;
  final String eventName;
  final String eventStartDate;
  final String eventEndDate;
  final String eventOrganizer;
  final String eventImage;
  final String eventLocation;
  final String eventDetails;

  const EventDetails({
    Key? key,
    required this.userid,
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
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  bool isFollowing = false;
  String address = '';

  @override
  void initState() {
    super.initState();
    fetchAddress();
    checkIsFollowing();
  }

  Future<void> checkIsFollowing() async {
    try {
      String currentUserUid = FirebaseAuth.instance.currentUser?.uid ?? '';
      bool followed = await EventsDatabase.isEventFollowed(widget.eventId);
      setState(() {
        isFollowing = followed;
      });
    } catch (e) {
      print('Error checking if event is followed: $e');
    }
  }

  Future<void> fetchAddress() async {
    GeoPoint geoPoint = EventLocation.convertStringToGeoPoint(widget.eventLocation);
    String? result = await EventLocation.getEventLocation(context, geoPoint.latitude, geoPoint.longitude);
    setState(() {
      address = result ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    String currentUserUid = FirebaseAuth.instance.currentUser?.uid ?? '';
    bool isCurrentUserEventOwner = widget.userid == currentUserUid;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.eventName),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(widget.eventImage),
              ),
              SizedBox(height: 16),
              Text(widget.eventName, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.person_outline, color: Colors.blue),
                  SizedBox(width: 4),
                  Text('Organizer: ${widget.eventOrganizer}', style: TextStyle(fontSize: 16)),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.calendar_today_outlined, color: Colors.blue),
                  SizedBox(width: 4),
                  Text('Start Date: ${widget.eventStartDate}', style: TextStyle(fontSize: 16)),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.calendar_today_outlined, color: Colors.blue),
                  SizedBox(width: 4),
                  Text('End Date: ${widget.eventEndDate}', style: TextStyle(fontSize: 16)),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.location_on_outlined, color: Colors.blue),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'Location: ${address}',
                      style: TextStyle(fontSize: 16),
                      overflow: TextOverflow.ellipsis, // Handle overflow with ellipsis
                      maxLines: 2, // Set maximum number of lines to 2
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(widget.eventDetails, style: TextStyle(fontSize: 16)),
              ),
              SizedBox(height: 25),
              // Show the "Get Location" button always
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StyledButton(
                    text: "Get Location",
                    verticalPadding: 10,
                    onPressed: () {
                      setState(() {
                        // open location gmap
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 10),
              // Show the follow/unfollow button only if the current user is not the event owner
              if (!isCurrentUserEventOwner)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StyledButton(
                      text: isFollowing ? 'Unfollow' : 'Follow',
                      verticalPadding: 10,
                      onPressed: () async {
                        // Check if the user is currently following the event
                        if (isFollowing) {
                          // Unfollow the event by removing it from the followed events collection
                          try {
                            // Get the current user's ID
                            String currentUserUid = FirebaseAuth.instance.currentUser?.uid ?? '';
                            // Delete the document from the followed events collection
                            await EventsDatabase().deleteFollowedEvent(currentUserUid, widget.eventId);
                            // Update the UI to reflect that the user is not following the event anymore
                            setState(() {
                              isFollowing = false;
                            });
                          } catch (e) {
                            print('Error unfollowing event: $e');
                          }
                        } else {
                          // Follow the event by storing it in the followed events collection
                          try {
                            // Get the current user's ID
                            String currentUserUid = FirebaseAuth.instance.currentUser?.uid ?? '';
                            // Store the followed event in Firestore
                            await EventsDatabase().storeFollowedEvent(currentUserUid, widget.userid, widget.eventId);
                            // Update the UI to reflect that the user is now following the event
                            setState(() {
                              isFollowing = true;
                            });
                          } catch (e) {
                            print('Error following event: $e');
                          }
                        }
                      },
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
