import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:local_community_app/database/eventsdb.dart';
import 'package:local_community_app/database/userdb.dart';
import '../event/eventCard.dart';

class EventPage extends StatefulWidget {
  const EventPage({Key? key}) : super(key: key);

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  int filtervalue = 0;
  int _currentPage = 0;
  int _pageSize = 10;
  bool _isLoading = false;
  List<Map<String, dynamic>> events = [
    // Add your events here
    // Assuming you have more events...
  ];

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadMoreData();
    //_scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    //_scrollController.removeListener(_scrollListener);
    //_scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // reached the bottom
      _loadMoreData();
    }
  }

  Future<void> _refreshData() async 
  {
    setState(() {
      _currentPage = 0;
      events.clear(); // Clear existing events
    });

    setState(() 
    {
      // Add logic to fetch new events and populate the list
      // For demonstration purpose, I'm just adding some dummy events again
      _loadMoreData();
    });
  }

  void _loadMoreData() async 
  {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });

      print("Load data");

      await _fetchEvents();

      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchEvents() async 
  {
    List<Map<String, dynamic>> newEvents = await EventsDatabase.getAllEvents();
    if (newEvents.isNotEmpty) {
      setState(() {
        events.addAll(newEvents);

        _currentPage++;
      });
    }
  }

  List<Map<String, dynamic>> getPaginatedEvents() 
  {
    int startIndex = _currentPage * _pageSize;
    int endIndex = startIndex + _pageSize;

    if (startIndex >= events.length) 
    {
      return [];
    }

    return events.sublist(startIndex, endIndex.clamp(0, events.length));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(

          padding: const EdgeInsets.only(top: 5.0, left: 20.0, right: 4.0, bottom: 4.0),
          child: Image.asset('assets/images/logo.png'), // Replace with your logo image path
        ),
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Search',
            filled: true,
            fillColor: Colors.white,
            prefixIcon: Icon(Icons.search, color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: (value) {
            // Implement your search logic here
          },
        ),
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: CupertinoSlidingSegmentedControl<int>(
                    thumbColor: Colors.lightBlueAccent,
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
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: events.length + (_isLoading ? 1 : 0),
          itemBuilder: (BuildContext context, int index) {
            if (index == events.length && _isLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              final event = events[index];
              print(event);

              // Use FutureBuilder to asynchronously get the event organizer's username
              return FutureBuilder<String?>(
                future: Database().getUsernameByUserId(event['user_id']),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ListTile(
                      title: Text('Loading...'),
                    );
                  } else {
                    if (snapshot.hasError) {
                      return ListTile(
                        title: Text('Error loading organizer'),
                      );
                    } else {
                      String? organizer = snapshot.data;
                      return EventCard(
                        userId: event['user_id'],
                        eventId: event['event_id'],
                        eventName: event['event_name'],
                        eventStartDate: event['start_date'],
                        eventEndDate: event['end_date'],
                        eventOrganizer: organizer ?? 'Unknown',
                        eventImage: event['event_image'],
                        eventLocation: event['event_location'],
                        eventDetails: event['event_description'],
                      );
                    }
                  }
                },
              );
            }
          },
        ),
      ),
    );
  }
}