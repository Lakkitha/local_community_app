import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../event/eventCard.dart';

class EventPage extends StatefulWidget {
  const EventPage({Key? key}) : super(key: key);

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  int filtervalue = 0;
  List<Map<String, dynamic>> events = [
    // Add your events here
    {
      'eventName': 'Brithday Party',
      'eventStartDate': '01/01/2023',
      'eventEndDate': '02/01/2023',
      'eventOrganizer': 'Anya',
      'eventImage': 'assets/images/pic5.jpg',
      'eventLocation': 'Colombo, Sri Lanka',
      'eventDetails': 'lorem ipsum dolor sit amet consectetur adipiscing elit'
          'sed do eiusmod tempor incididunt ut labore et dolore magna aliqua'
          'ut enim ad minim veniam quis nostrud exercitation ullamco laboris',
    },
    {
      'eventName': 'Event 2',
      'eventStartDate': '01/01/2023',
      'eventEndDate': '02/01/2023',
      'eventOrganizer': 'Organizer 2',
      'eventImage': 'assets/images/img.jpg',
      'eventLocation': 'Location 2',
      'eventDetails': 'lorem ipsum dolor sit amet consectetur adipiscing elit'
          'sed do eiusmod tempor incididunt ut labore et dolore magna aliqua'
          'ut enim ad minim veniam quis nostrud exercitation ullamco laboris',
    },
    {
      'eventName': 'Event 3',
      'eventStartDate': '01/01/2023',
      'eventEndDate': '02/01/2023',
      'eventOrganizer': 'Organizer 3',
      'eventImage': 'assets/images/img.jpg',
      'eventLocation': 'Location 3',
      'eventDetails': 'lorem ipsum dolor sit amet consectetur adipiscing elit'
          'sed do eiusmod tempor incididunt ut labore et dolore magna aliqua'
          'ut enim ad minim veniam quis nostrud exercitation ullamco laboris',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Events",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            )),
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: CupertinoSlidingSegmentedControl<int>(
                    children: {
                      0: Text('Global'),
                      1: Text('Local'),
                    },
                    groupValue: filtervalue,
                    onValueChanged: (int? newValue) {
                      setState(() {
                        //Use the Filter logic here
                        filtervalue = newValue!;
                        print("Filter Value: $filtervalue");
                      });
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.event),
                  onPressed: () {
                    // Add Followed Event Logic here
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (BuildContext context, int index) {
          return EventCard(
            eventName: events[index]['eventName'],
            eventStartDate: events[index]['eventStartDate'],
            eventEndDate: events[index]['eventEndDate'],
            eventOrganizer: events[index]['eventOrganizer'],
            eventImage: events[index]['eventImage'],
            eventLocation: events[index]['eventLocation'],
            eventDetails: events[index]['eventDetails'],
          );
        },
      ),
    );
  }
}