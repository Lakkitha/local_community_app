import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EventsDatabase
{
	// Method to store user data
	Future<void> storeUserEventData(String uid, String eventName, String startDate, String endDate, LatLng latLng,
								String description, String imageUrl, int followers) async 
	{
		try 
		{
			await FirebaseFirestore.instance.collection('users').doc(uid).collection('events').doc().set({
				'event_name': eventName,
				'start_date': startDate,
				'end_date': endDate,
				'event_location': latLng.latitude.toString() + ', ' + latLng.longitude.toString(),
				'event_description': description,
				'event_image': imageUrl,
				'event_followers': followers,
				// Add additional fields as needed
			});
			print('Event info stored in Firestore successfully');
		} 
		catch (e) 
		{
			print('Error storing event info in Firestore: $e');
		}
	}

	// Method to retrieve events for a user
	Future<List<Map<String, dynamic>>> getUserEvents(String uid) async 
	{
		List<Map<String, dynamic>> userEvents = [];

		try 
		{
			QuerySnapshot eventsSnapshot =
					await FirebaseFirestore.instance.collection('users').doc(uid).collection('events').get();
			eventsSnapshot.docs.forEach((eventDoc) 
			{
				Map<String, dynamic>? eventData = eventDoc.data() as Map<String, dynamic>?;
				
				if (eventData != null) 
				{
					eventData['event_id'] = eventDoc.id; // Add event ID to the map
					userEvents.add(eventData);
				}
			});

		} 
		catch (e) 
		{
			print('Error retrieving user events: $e');
		}
		
		return userEvents;
	}
}