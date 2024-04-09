import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddEventPage extends StatefulWidget {
  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  bool _showFullDescription = false;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  List<Widget> _eventCards = [];
  File? _image;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(primarySwatch: Colors.pink),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pink,
          title: Text('Add Event', style: TextStyle(color: Colors.white)),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Event Title',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an event title';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  _buildDateField('Start Date', _startDate, (DateTime date) {
                    setState(() {
                      _startDate = date;
                    });
                  }),
                  SizedBox(height: 16.0),
                  _buildDateField('End Date', _endDate, (DateTime date) {
                    setState(() {
                      _endDate = date;
                    });
                  }),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      labelText: 'Event Location',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an event location';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  _buildDescriptionField('Description'),
                  SizedBox(height: 16.0),
                  _imagePickerButton(),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _addEventCard();
                      }
                    },
                    child: Text('Add Event',
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  if (_eventCards.isNotEmpty) ...[
                    _buildEventDetailsSection(),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateField(String labelText, DateTime selectedDate,
      Function(DateTime) onDateChanged) {
    return InkWell(
      onTap: () => _selectDate(context, selectedDate, onDateChanged),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(labelText),
            Text(selectedDate.toString().split(' ')[0]),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionField(String labelText) {
    final int wordLimit = 20; // Set the desired word limit

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _descriptionController,
          decoration: InputDecoration(
            labelText: labelText,
            border: OutlineInputBorder(),
          ),
          maxLines: _showFullDescription ? null : 3,
        ),
        if (_descriptionController.text.isNotEmpty &&
            _descriptionController.text
                .split(' ')
                .length > wordLimit)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                setState(() {
                  _showFullDescription = !_showFullDescription;
                });
              },
              child: Text(
                _showFullDescription ? 'Read less' : 'Read more',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ),
      ],
    );
  }
}