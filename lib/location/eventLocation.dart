import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';

class EventLocation
{
	static GeoPoint convertStringToGeoPoint(String locationString) 
	{
    List<String> coordinates = locationString.split(',');
    double latitude = double.parse(coordinates[0]);
    double longitude = double.parse(coordinates[1]);
    return GeoPoint(latitude, longitude);
  }

  static Future<String?> getEventLocation(BuildContext context, lat, double lng) async
  {
    List<Placemark> placemarks = await placemarkFromCoordinates(
          lat, lng);
      Placemark place = placemarks[0];

    if (!placemarks.isEmpty)
    {
      return place.name.toString() + ', ' + place.country.toString();
    }
    else
      return null;
  }

	static Future<String?> getEventStreet(BuildContext context, lat, double lng) async
  {
    List<Placemark> placemarks = await placemarkFromCoordinates(
          lat, lng);
      Placemark place = placemarks[0];

    if (!placemarks.isEmpty)
    {
      return place.subAdministrativeArea.toString() + ', ' + place.country.toString();
    }
    else
      return null;
  }
}