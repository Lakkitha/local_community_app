import 'package:firebase_auth/firebase_auth.dart';

class FireBaseAuthService
{
	FirebaseAuth _auth = FirebaseAuth.instance;

	/// Asynchronous method to sign up with email and password
	///
	Future<User?> signUpWithEmailAndPassword(String email, String password) async 
	{
		try 
		{
			UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
			return credential.user;
		}
		catch (e)
		{
			print("Error " + e.toString());
		}

		return null;
	}

	/// Asynchronous method to login with email and password
	///
	Future<User?> signInWithEmailAndPassword(String email, String password) async 
	{
		try 
		{
			UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
			return credential.user;
		}
		catch (e)
		{
			print("Error " + e.toString());
		}

		return null;
	}
}