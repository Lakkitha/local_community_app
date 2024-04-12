import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

	static Future<List<Map<String, dynamic>>> getEventsByFollowersBatch(int batchSize, DocumentSnapshot? lastDocument) async 
	{
		List<Map<String, dynamic>> events = [];

		try {
			Query query = FirebaseFirestore.instance.collection('users');

			if (lastDocument != null) {
				// If a last document is provided, start after it to paginate
				query = query.startAfterDocument(lastDocument);
			}

			QuerySnapshot usersSnapshot = await query.get();

			// Iterate through each user
			for (DocumentSnapshot userDoc in usersSnapshot.docs) {
				// Get the events collection for the current user
				QuerySnapshot eventsSnapshot = await userDoc.reference.collection('events')
					.orderBy('event_followers', descending: true)
					.limit(batchSize)
					.get();

				// Add events to the list
				eventsSnapshot.docs.forEach((eventDoc) {
					Map<String, dynamic>? eventData = eventDoc.data() as Map<String, dynamic>?;

					if (eventData != null) {
						eventData['event_id'] = eventDoc.id; // Add event ID to the map
						events.add(eventData);
					}
				});
			}
		} catch (e) {
			print('Error retrieving events: $e');
		}

		return events;
	}

	static Future<List<Map<String, dynamic>>> getAllEvents() async 
	{
		List<Map<String, dynamic>> events = [];

		try {
			String currentUserUid = FirebaseAuth.instance.currentUser?.uid ?? '';

			// Query all users
			QuerySnapshot usersSnapshot = await FirebaseFirestore.instance.collection('users').get();

			// Iterate through each user
			for (DocumentSnapshot userDoc in usersSnapshot.docs) {
				String userUid = userDoc.id;

				// Skip if the user is the current user
				if (userUid == currentUserUid) {
					continue;
				}

				// Get the events collection for the current user
				QuerySnapshot eventsSnapshot = await userDoc.reference.collection('events').get();

				// Add events to the list
				eventsSnapshot.docs.forEach((eventDoc) {
					Map<String, dynamic>? eventData = eventDoc.data() as Map<String, dynamic>?;

					if (eventData != null) {
						eventData['event_id'] = eventDoc.id; // Add event ID to the map
						eventData['user_id'] = userUid; // Add user ID to the map
						events.add(eventData);
					}
				});
			}
		} catch (e) {
			print('Error retrieving events: $e');
		}

		return events;
	}

	Future<void> storeFollowedEvent(String uid, String userId, String eventid) async 
	{
		try 
		{
			await FirebaseFirestore.instance.collection('users').doc(uid).collection('followed_events').doc(eventid).set({
				'eventid': eventid,
				'userid': userId,
			});
			print('Event info stored in Firestore successfully');
		} 
		catch (e) 
		{
			print('Error storing event info in Firestore: $e');
		}
	}

	Future<void> deleteFollowedEvent(String uid, String eventId) async 
	{
		try {
			await FirebaseFirestore.instance
					.collection('users')
					.doc(uid)
					.collection('followed_events')
					.doc(eventId)
					.delete();
			print('Event info deleted from Firestore successfully');
		} catch (e) {
			print('Error deleting event info from Firestore: $e');
		}
	}

	static Future<List<Map<String, dynamic>>> getAllFollowedEventsUser() async 
	{
		List<Map<String, dynamic>> events = [];

		try {
			// Get the current user's ID
			String currentUserUid = FirebaseAuth.instance.currentUser?.uid ?? '';

			// Query the followed events collection of the current user
			QuerySnapshot eventsSnapshot = await FirebaseFirestore.instance
				.collection('users')
				.doc(currentUserUid) // Target the current user's document
				.collection('followed_events') // Target the followed events collection
				.get();

			// Iterate through each followed event
			eventsSnapshot.docs.forEach((eventDoc) {
			Map<String, dynamic>? eventData = eventDoc.data() as Map<String, dynamic>?;

			if (eventData != null) {
				events.add(eventData);
			}
			});
		} catch (e) {
			print('Error retrieving events: $e');
		}

		return events;
	}

	// Function to check if the given event is followed by the current user
	static Future<bool> isEventFollowed(String eventId) async 
	{
		try 
		{
			// Get the current user's ID
			String currentUserUid = FirebaseAuth.instance.currentUser?.uid ?? '';

			// Query the followed events collection of the current user
			QuerySnapshot eventsSnapshot = await FirebaseFirestore.instance
				.collection('users')
				.doc(currentUserUid) // Target the current user's document
				.collection('followed_events') // Target the followed events collection
				.where('eventid', isEqualTo: eventId) // Filter by eventid
				.get();

			// If any documents are found, the event is followed
			return eventsSnapshot.docs.isNotEmpty;
		} 
		catch (e) 
		{
			print('Error checking if event is followed: $e');
			return false;
		}
	}
}