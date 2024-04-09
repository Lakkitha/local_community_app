import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'EventCard.dart';

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
      'eventName': 'Event 1',
      'eventStartDate': '01/01/2023',
      'eventEndDate': '02/01/2023',
      'eventOrganizer': 'Organizer 1',
      'eventImage': 'assets/images/img.jpg',
    },
    {
      'eventName': 'Event 2',
      'eventStartDate': '01/01/2023',
      'eventEndDate': '02/01/2023',
      'eventOrganizer': 'Organizer 2',
      'eventImage': 'assets/images/img.jpg',
    },
    {
      'eventName': 'Event 3',
      'eventStartDate': '01/01/2023',
      'eventEndDate': '02/01/2023',
      'eventOrganizer': 'Organizer 3',
      'eventImage': 'assets/images/img.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 10.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text("Events",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  )),
            ),
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
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return EventCard(
                  eventName: events[index]['eventName'],
                  eventStartDate: events[index]['eventStartDate'],
                  eventEndDate: events[index]['eventEndDate'],
                  eventOrganizer: events[index]['eventOrganizer'],
                  eventImage: events[index]['eventImage'],
                );
              },
              childCount: events.length,
            ),
          ),
        ],
      ),
    );
  }
}