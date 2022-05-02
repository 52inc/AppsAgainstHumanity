// import 'dart:io';
import 'dart:typed_data';

import 'package:appsagainsthumanity/data/app_preferences.dart';
import 'package:appsagainsthumanity/data/features/game/model/player.dart';
import 'package:appsagainsthumanity/data/features/users/model/user.dart';
import 'package:appsagainsthumanity/data/firestore.dart';
import 'package:appsagainsthumanity/internal/push.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logging/logging.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class UserRepository {
  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<bool> isSignedIn() async {
    return _auth.currentUser != null;
  }

  Future<User> getUser() {
    return currentUserOrThrow((firebaseUser) async {
      var doc = _userDocument(firebaseUser);
      var snapshot = await doc.get();
      return User(
          id: doc.id,
          name: snapshot['name'],
          avatarUrl: snapshot['avatarUrl'],
          updatedAt: (snapshot['updatedAt'] as Timestamp).toDate());
    });
  }

  Stream<User> observeUser() {
    return streamCurrentUserOrThrow((firebaseUser) {
      var doc = _userDocument(firebaseUser);
      return doc.snapshots().map((snapshot) {
        return User(
          id: snapshot.id,
          name: snapshot['name'] ?? Player.DEFAULT_NAME,
          avatarUrl: snapshot['avatarUrl'],
          updatedAt: (snapshot['updatedAt'] as Timestamp).toDate(),
        );
      });
    });
  }

  Future<void> updateDisplayName(String name) {
    return currentUserOrThrow((firebaseUser) async {
      // Be sure to update our Auth Obj
      await firebaseUser.updateDisplayName(name);
      await firebaseUser.updatePhotoURL(firebaseUser.photoURL);

      await _userDocument(firebaseUser).update({
        'name': name,
        'updatedAt': Timestamp.now(),
      });
    });
  }

  Future<void> deleteProfilePhoto() {
    return currentUserOrThrow((firebaseUser) async {
      var ref = _profilePhotoReference(firebaseUser);
      await ref.delete();

      // Be sure to update our Auth Obj
      await firebaseUser.updateDisplayName(firebaseUser.displayName);
      await firebaseUser.updatePhotoURL("");

      await _userDocument(firebaseUser).update({
        'avatarUrl': null,
        'updatedAt': Timestamp.now(),
      });
    });
  }

  Future<void> updateProfilePhoto(Uint8List imageBytes) {
    return currentUserOrThrow((firebaseUser) async {
      var ref = _profilePhotoReference(firebaseUser);
      var refSnapshot = await ref.putData(imageBytes);
      var downloadUrl = await refSnapshot.ref.getDownloadURL();

      // Be sure to update our Auth Obj
      await firebaseUser.updateDisplayName(firebaseUser.displayName);
      await firebaseUser.updatePhotoURL(downloadUrl);

      await _userDocument(firebaseUser).update({
        'avatarUrl': downloadUrl.toString(),
        'updatedAt': Timestamp.now(),
      });
    });
  }

  Future<User> signInWithGoogle() async {
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/userinfo.profile',
      ],
    );

    try {
      var acct = await _googleSignIn.signIn();
      var auth = await acct?.authentication;

      var result = await _auth.signInWithCredential(
        fb.GoogleAuthProvider.credential(
          idToken: auth?.idToken,
          accessToken: auth?.accessToken,
        ),
      );

      return _finishSigningInWithResult(result);
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<User> signInWithApple() async {
    final result = await SignInWithApple.getAppleIDCredential(scopes: [
      AppleIDAuthorizationScopes.email,
      AppleIDAuthorizationScopes.fullName,
    ]);

    // Success
    fb.OAuthProvider oAuthProvider = fb.OAuthProvider('apple.com');
    final fb.AuthCredential credential = oAuthProvider.credential(
      idToken: result.identityToken,
      accessToken: result.authorizationCode,
    );

    var name = Player.DEFAULT_NAME;
    if (result.givenName != "") {
      print(
          "Apple Name(given=${result.givenName}, family=${result.familyName})");
      name = result.givenName!;
    }

    final fb.UserCredential _result =
        await _auth.signInWithCredential(credential);
    return _finishSigningInWithResult(_result, name: name);
  }

  Future<User> signInWithEmail(String email, String password) async {
    final fb.UserCredential _result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return _finishSigningInWithResult(_result);
  }

  Future<User> signUpWithEmail(String email, String password,
      [String? username]) async {
    final fb.UserCredential _result = await _auth
        .createUserWithEmailAndPassword(email: email, password: password);
    return _finishSigningInWithResult(_result, name: username!);
  }

  Future<User> signInAnonymously() async {
    final fb.UserCredential _result = await _auth.signInAnonymously();
    return _finishSigningInWithResult(_result);
  }

  Future<User> _finishSigningInWithResult(fb.UserCredential result,
      {String? name}) async {
    try {
      if (result.user != null) {
        if (name != null && result.user?.displayName != name) {
          await result.user?.updateDisplayName(name);
          await result.user?.updatePhotoURL(result.user?.photoURL);
          await result.user?.reload();
          print("Updated user's name to ${result.user?.displayName}");
        }

        // Create the user obj acct in FB
        var userDoc = _userDocument(result.user!);

        await userDoc.set({
          "name": result.user?.displayName,
          "avatarUrl": result.user?.photoURL,
          "updatedAt": Timestamp.now(),
        }, SetOptions(merge: true));

        Logger("UserRepository").fine(
            "Signed-in! User(id=${result.user?.uid}, name=${result.user?.displayName}, photoUrl=${result.user?.photoURL})");

        // Excellent! Let's create our device
        await PushNotifications().checkAndUpdateToken(force: true);

        return User(
          id: result.user!.uid,
          name: result.user!.displayName!,
          avatarUrl: result.user!.photoURL!,
          updatedAt: DateTime.now(),
        );
      } else {
        throw result;
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }

  /// Sign-out of the user's account
  Future<void> signOut() async {
    await AppPreferences().clear();
    await _auth.signOut();
  }

  Future<void> deleteAccount() async {
    await AppPreferences().clear();
    var user = _auth.currentUser;
    await user?.delete();
    await _profilePhotoReference(user!).delete();
  }

  DocumentReference _userDocument(fb.User user) {
    return _db.collection(FirebaseConstants.COLLECTION_USERS).doc(user.uid);
  }

  Reference _profilePhotoReference(fb.User user) {
    return _storage
        .ref()
        .child(FirebaseConstants.COLLECTION_USERS)
        .child(user.uid);
  }
}
