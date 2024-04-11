import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../util/styled_button.dart';
import '../util/styled_textfield.dart';

class ImageUpload extends StatefulWidget {
  @override
  _ImageUploadState createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> 
{
  String? imageUrl;
  File? imageFile;
  bool hasUploaded = false; // Flag to track if an image has been uploaded
  bool isUploading = false; // Flag to track if image is currently being uploaded
  
  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Upload Image',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      
      body: Stack(
        children: [
          if (!isUploading) // Render UI elements only if not uploading
            Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(15),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                      border: Border.all(color: Colors.white),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(2, 2),
                          spreadRadius: 2,
                          blurRadius: 1,
                        ),
                      ],
                    ),
                    child: (imageFile != null)
                        ? Image.file(imageFile!)
                        : Image.network('https://i.imgur.com/sUFH1Aq.png'),
                  ),
                  SizedBox(height: 20.0),
                  StyledButton(
                    text: hasUploaded ? 'Re-upload Image' : 'Upload Image',
                    verticalPadding: 10,
                    onPressed: () {
                      pickImage();
                    },
                  ),
                ],
              ),
            ),

          if (isUploading) // Render loading indicator if uploading
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  final _firebaseStorage = FirebaseStorage.instance;
  final _imagePicker = ImagePicker();

  Future<void> pickImage() async
  {
    isUploading = true;
    XFile? image;

    // Get permission to access the device gallery
    var permissionStatus = await Permission.photos.request();

    if (permissionStatus.isGranted)
    {
      // Select Image
      image = await _imagePicker.pickImage(source: ImageSource.gallery);

      if (image != null)
      {
        var file = File(image.path);

        setState(() 
        {
          imageFile = file;
          hasUploaded = true; // Set flag to true after successful upload
          isUploading = false; // Hide loading indicator
        });

      }
      else 
      {
        print('No Image Path Received');

        setState(() 
        {
          isUploading = false; // Hide loading indicator
        });
      }
    }
    else 
    {
      print('Permission not granted. Try Again with permission access');

      setState(() 
      {
        isUploading = false; // Hide loading indicator
      });
    }
  }

  Future<void> uploadImage() async 
  {
    // Get the UID of the current user
    String? uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid != null) 
    {
      // Generate a random number
      var randomNumber = Random().nextInt(10000);

      // Generate the image name using the user's UID and random number
      var imageName = '$uid-$randomNumber.png'; // Combine UID and random number with .png extension

      // Upload to Firebase
      var file = imageFile!;
      
      var snapshot = await _firebaseStorage
          .ref()
          .child('images/$uid/$imageName')
          .putFile(file);
      
      var downloadUrl = await snapshot.ref.getDownloadURL();

      imageUrl = downloadUrl;
      imageFile = null;

      hasUploaded = false;

      print("Image url uploaded: " + imageUrl.toString());
      print("Is Uploading: " + isUploading.toString());
    } 
    else 
    {
      print('User not authenticated');
    }
  }

  Future<void> reuploadImage() async 
  {
    // Show a dialog to confirm re-upload
    bool confirmReupload = await showDialog(

      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Re-upload'),
        content: Text('Are you sure you want to re-upload the image? This will replace the current image.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Cancel re-upload
            },
            child: Text('Cancel'),
          ),

          TextButton(
            onPressed: () async
            {
              Navigator.of(context).pop(true); // Confirm re-upload

              // Delete the existing image from Firebase Storage
              String? uid = FirebaseAuth.instance.currentUser?.uid;

              if (uid != null) 
              {
                var oldImageUrl = imageUrl;
                
                if (oldImageUrl != null) 
                {
                  var oldImageRef = _firebaseStorage.refFromURL(oldImageUrl);
                  await oldImageRef.delete();
                }
              }

              // Remove the preview image
              setState(() 
              {
                imageUrl = null;
              });
            },

            child: Text('Confirm'),
          ),
        ],
      ),
    );

    // Proceed with re-upload if confirmed
    if (confirmReupload == true) 
    {
      setState(() 
      {
        isUploading = true; // Show loading indicator
      });

      // Upload the new image
      await uploadImage();
    }
  }
}

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
  Set<Marker> _markers = Set();
  late GoogleMapController? _mapController;
  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(primarySwatch: Colors.blue),
      child: Scaffold(
        body: Stack(
          children: [
            _buildFormContent(), // Render form content
            if (_isUploading) // Render loading indicator if uploading
              _buildLoadingIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildFormContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title Widget
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  'Add Event',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Adjust the color as needed
                  ),
                ),
              ),
              StyledTextField(
                controller: _titleController,
                hintText: 'Enter event name',
                labelText: 'Event Name',
                onChanged: (value) {
                  setState(() {
                    if (value == null || value.isEmpty) {
                      return;
                    }
                    return null;
                  });
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
              StyledTextField(
                controller: _locationController,
                hintText: 'Enter event location',
                labelText: 'Event Location',
                onChanged: (value) {
                  setState(() {
                    if (value == null || value.isEmpty) {
                      return;
                    }
                    return null;
                  });
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
                onPressed: () async {
                  if (_formKey.currentState!.validate()) 
                  {
                    setState(() {
                      _isUploading = true;
                    });

                    print("Is uploading on events page: " + _isUploading.toString());
                    _ImageUploadState upload = _ImageUploadState();
                    await upload.uploadImage();

                    setState(() {
                      _isUploading = false;
                    });

                    print("Is uploading on events page: " + _isUploading.toString());
                    
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
    );
  }

  Widget _buildLoadingIndicator() {
  return Positioned.fill(
    child: Container(
      color: Colors.black.withOpacity(0.5),
      // You can customize the color and opacity as needed
      child: Center(
        child: CircularProgressIndicator(), // Display loading indicator
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
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ImageUpload()),
        );
      },
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

              markers: _markers.map((e) => e).toSet(),
              mapType: MapType.normal,
              zoomControlsEnabled: true,
              myLocationButtonEnabled: true,
              onTap: _addMarkerFromDialog,
              
              onMapCreated: (GoogleMapController controller) 
              {
                _mapController = controller;

                if (!_markers.first.position.isBlank!)
                {
                  _mapController!.moveCamera(CameraUpdate.newLatLng(_markers.first.position));
                }
              },
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

      print("Tapped marker at " + position.latitude.toString() + ", " + position.longitude.toString());

      // Update location text field with latitude and longitude
      _locationController.text = '${position.latitude}, ${position.longitude}';

      // Move the camera to the tapped position
      _mapController!.animateCamera(CameraUpdate.newLatLng(position));
    });
  }
}
