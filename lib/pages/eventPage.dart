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
  List<Map<String, dynamic>> events = [];

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

  Future<void> _refreshData() async {
    setState(() {
      _currentPage = 0;
      events.clear(); // Clear existing events
    });

    setState(() {
      // Add logic to fetch new events and populate the list
      // For demonstration purpose, I'm just adding some dummy events again
      _loadMoreData();
    });
  }

  void _loadMoreData() async {
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

  Future<void> _fetchEvents() async {
    events.clear();

    if (filtervalue == 0) {
      // Global filter
      List<Map<String, dynamic>> newEvents = await EventsDatabase.getAllEvents();
      if (newEvents.isNotEmpty) {
        setState(() {
          events.addAll(newEvents);
          _currentPage++;
        });
      }
    } else if (filtervalue == 2) {
      // Following filter
      List<Map<String, dynamic>> followedEvents = await EventsDatabase.getAllFollowedEventsUser(filterOnly: true);
      print(followedEvents);

      if (followedEvents.isNotEmpty) {
        setState(() {
          events.addAll(followedEvents);
          _currentPage++;
        });
      }
    }
  }

  List<Map<String, dynamic>> filterEventsByName(String searchText) {
    return events.where((event) {
      String eventName = event['event_name'].toLowerCase();
      return eventName.contains(searchText.toLowerCase());
    }).toList();
  }

  String _searchText = '';

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
            setState(() {
              _searchText = value;
            });
          },
        ),
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: CupertinoSlidingSegmentedControl<int>(
                        thumbColor: Colors.lightBlueAccent,
                        children: {
                          0: Text('Global'),
                          1: Text('Local'),
                          2: Text('Following'),
                        },
                        groupValue: filtervalue,
                        onValueChanged: (int? newValue) {
                          setState(() {
                            filtervalue = newValue!;
                            _loadMoreData();
                            print("Filter Value: $filtervalue");
                          });
                        },
                      ),
                    ),
                  ],
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
          itemCount: filterEventsByName(_searchText).length + (_isLoading ? 1 : 0),
          itemBuilder: (BuildContext context, int index) {
            List<Map<String, dynamic>> filteredEvents = filterEventsByName(_searchText);
            if (index == filteredEvents.length && _isLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              final event = filteredEvents[index];

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
