import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmailValidator {
  static bool isValid(String email) {
    final emailPattern = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
      caseSensitive: false,
      multiLine: false,
    );
    return emailPattern.hasMatch(email);
  }

  
  // Method to check if the email is already registered
  static Future<bool> checkIfEmailExists(String email) async {
    try {
      // Attempt to create a temporary user with the provided email
      UserCredential credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: 'temporary_password', // Provide a temporary password
      );
      
      // If successful, delete the temporary user and return true
      await credential.user?.delete();
      return false; // User doesn't exist (email is available)
    } 
    catch (e) 
    {
      // If an error occurs, check if it's an email-already-in-use error
      if (e is FirebaseAuthException && e.code == 'email-already-in-use') {
        return true; // User already exists (email is taken)
      }
      // If it's not an email-already-in-use error, return false
      print('Error checking email existence: $e');
      
      return false;
    }
  }
}

