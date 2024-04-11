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
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // reached the bottom
      _loadMoreData();
    }
  }

  void _loadMoreData() async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });

      // Simulate loading delay
      await Future.delayed(Duration(seconds: 2));

      setState(() {
        _currentPage++;
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _currentPage = 0;
      events.clear(); // Clear existing events
    });

    // Simulate loading delay
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      // Add logic to fetch new events and populate the list
      // For demonstration purpose, I'm just adding some dummy events again
      events.addAll([
        // Add more events here
      ]);
    });
  }

  List<Map<String, dynamic>> getPaginatedEvents() {
    int startIndex = _currentPage * _pageSize;
    int endIndex = startIndex + _pageSize;
    if (startIndex >= events.length) {
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
          itemCount: getPaginatedEvents().length + (_isLoading ? 1 : 0),
          itemBuilder: (BuildContext context, int index) {
            if (index == getPaginatedEvents().length && _isLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              final event = getPaginatedEvents()[index];
              return EventCard(
                eventId: event['eventId'],
                eventName: event['eventName'],
                eventStartDate: event['eventStartDate'],
                eventEndDate: event['eventEndDate'],
                eventOrganizer: event['eventOrganizer'],
                eventImage: event['eventImage'],
                eventLocation: event['eventLocation'],
                eventDetails: event['eventDetails'],
              );
            }
          },
        ),
      ),
    );
  }
}