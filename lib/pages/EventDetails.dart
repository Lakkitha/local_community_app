import 'package:flutter/material.dart';

class EventDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Details'),
      ),
      body: Center(
        child: Text(
          'Event Details Placeholder',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}