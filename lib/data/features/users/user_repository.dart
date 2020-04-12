import 'package:appsagainsthumanity/data/app_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  final FirebaseAuth _auth;

  final Firestore _db = Firestore.instance;

  UserRepository({FirebaseAuth firebaseAuth})
      : _auth = firebaseAuth ?? FirebaseAuth.instance;

  Future<bool> isSignedIn() async {
    return (await _auth.currentUser()) != null;
  }

  Future<FirebaseUser> getUser() async {
    return await _auth.currentUser();
  }

  /// Sign-out of the user's account
  Future<void> signOut() async {
    await AppPreferences().clear();
    await _auth.signOut();
  }
}
