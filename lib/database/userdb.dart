import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Database
{
	// Method to store user data
	Future<void> storeUserInfo(String uid, String email, String username, String date, String gender) async 
	{
		try 
		{
		await FirebaseFirestore.instance.collection('users').doc(uid).set({
			'email': email,
			'username': username,
			'date_of_birth': date,
			'gender': gender,
			// Add additional fields as needed
		});
		print('User info stored in Firestore successfully');
		} 
		catch (e) {
		print('Error storing user info in Firestore: $e');
		}
	}
	
  // Method to get data for the current user
  Future<Map<String, dynamic>?> getCurrentUserData(String uid) async {
    try {
      // Reference to the document for the current user
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      // Check if the document exists
      if (userDoc.exists) {
        // Return the data for the current user
        return userDoc.data() as Map<String, dynamic>;
      } else {
        // User document does not exist
        print('User document does not exist');
        return null;
      }
    } catch (e) {
      // Handle any errors
      print('Error retrieving current user data: $e');
      return null;
    }
  }
}
