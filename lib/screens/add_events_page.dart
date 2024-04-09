import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  Set<Marker> _markers = {};

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
                  ElevatedButton.icon(
                    onPressed: _showMapSelectionDialog,
                    icon: Icon(
                      Icons.location_on,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Select from Map',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: _buildButtonStyle(),
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
                    child: Text(
                      'Add Event',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
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

  Widget _buildDateField(String labelText, DateTime selectedDate, Function(DateTime) onDateChanged) {
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
    final List<String> words = _descriptionController.text.split(' ');

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
        if (words.length > wordLimit && !_showFullDescription)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                setState(() {
                  _showFullDescription = true;
                });
              },
              child: Text('Read more'),
            ),
          ),
        if (!_showFullDescription)
          Text(
            words.take(wordLimit).join(' ') + (words.length > wordLimit ? '...' : ''),
            style: TextStyle(color: Colors.grey),
          ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context, DateTime initialDate, Function(DateTime) onDateChanged) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != initialDate) {
      onDateChanged(picked);
    }
  }

  void _addEventCard() {
    setState(() {
      _eventCards.add(
        SizedBox(
          width: double.infinity,
          child: Card(
            elevation: 4.0,
            margin: EdgeInsets.symmetric(vertical: 8.0),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _titleController.text,
                          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8.0),
                        Text('Start Date: ${_startDate.toString().split(' ')[0]}'),
                        Text('End Date: ${_endDate.toString().split(' ')[0]}'),
                        Text('Location: ${_locationController.text}'),
                        Text('Description: ${_descriptionController.text}'),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _eventCards.removeLast(); // Remove the last added event card
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Clear form fields
      _titleController.clear();
      _descriptionController.clear();
      _locationController.clear();
      _showFullDescription = false;
      _startDate = DateTime.now();
      _endDate = DateTime.now();
      _image = null;
    });
  }

  Widget _buildEventDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Event Details',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.0),
        ..._eventCards,
      ],
    );
  }

  Widget _imagePickerButton() {
    return ElevatedButton.icon(
      onPressed: _getImage,
      icon: Icon(
        Icons.add_a_photo,
        color: Colors.white, // Set icon color to white
      ),
      label: Text(
        'Add Image',
        style: TextStyle(color: Colors.white),
      ),
      style: _buildButtonStyle(),
    );
  }

  Future<void> _getImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (image != null) {
        _image = File(image.path);
      }
    });
  }

  void _showMapSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Location from Map'),
          content: Container(
            height: 400,
            width: 400,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(6.822245248616214, 80.04159435772131),
                zoom: 15,
              ),
              onMapCreated: (GoogleMapController controller) {},
              onTap: _addMarkerFromDialog,
              markers: _markers,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(null); // Return none when canceled
              },
              child: Text('CANCEL'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('CONFIRM'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.pink, // Set the text color
              ),
            ),
          ],
        );
      },
    );
  }

  ButtonStyle _buildButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.pink,
    );
  }

  void _addMarkerFromDialog(LatLng position) {
    setState(() {
      _markers.clear(); // Clear existing markers
      _markers.add(
        Marker(
          markerId: MarkerId(position.toString()),
          position: position,
          infoWindow: InfoWindow(
            title: 'Selected Location',
            snippet: '${position.latitude}, ${position.longitude}',
          ),
        ),
      );

      // Update location text field with latitude and longitude
      _locationController.text = '${position.latitude}, ${position.longitude}';
    });
  }
}
