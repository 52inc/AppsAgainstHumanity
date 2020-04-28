import 'dart:io';

import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:appsagainsthumanity/data/app_preferences.dart';
import 'package:appsagainsthumanity/data/features/game/model/player.dart';
import 'package:appsagainsthumanity/data/features/users/model/user.dart';
import 'package:appsagainsthumanity/data/firestore.dart';
import 'package:appsagainsthumanity/internal/push.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logging/logging.dart';

class UserRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<bool> isSignedIn() async {
    return (await _auth.currentUser()) != null;
  }

  Future<User> getUser() {
    return currentUserOrThrow((firebaseUser) async {
      var doc = _userDocument(firebaseUser);
      var snapshot = await doc.get();
      return User(
          id: doc.documentID,
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
            id: snapshot.documentID,
            name: snapshot['name'],
            avatarUrl: snapshot['avatarUrl'],
            updatedAt: (snapshot['updatedAt'] as Timestamp).toDate(),
        );
      });
    });
  }

  Future<void> updateDisplayName(String name) {
    return currentUserOrThrow((firebaseUser) async {
      await _userDocument(firebaseUser).updateData({
        'name': name
      });
    });
  }

  Future<void> deleteProfilePhoto() {
    return currentUserOrThrow((firebaseUser) async {
      var ref = _profilePhotoReference(firebaseUser);
      await ref.delete();

      await _userDocument(firebaseUser).updateData({
        'avatarUrl': null
      });
    });
  }

  Future<void> updateProfilePhoto(File image) {
    return currentUserOrThrow((firebaseUser) async {
      var ref = _profilePhotoReference(firebaseUser);
      var refSnapshot = await ref.putFile(image).onComplete;
      var downloadUrl = await refSnapshot.ref.getDownloadURL();

      await _userDocument(firebaseUser).updateData({
        'avatarUrl': downloadUrl.toString()
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
      var auth = await acct.authentication;

      var result = await _auth
          .signInWithCredential(GoogleAuthProvider.getCredential(idToken: auth.idToken, accessToken: auth.accessToken));

      return _finishSigningInWithResult(result);
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<User> signInWithApple() async {
    final AuthorizationResult result = await AppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);

    switch (result.status) {
      case AuthorizationStatus.authorized:
        // Success
        final AppleIdCredential appleIdCredential = result.credential;
        OAuthProvider oAuthProvider = OAuthProvider(providerId: "apple.com");
        final AuthCredential credential = oAuthProvider.getCredential(
          idToken: String.fromCharCodes(appleIdCredential.identityToken),
          accessToken: String.fromCharCodes(appleIdCredential.authorizationCode),
        );

        var name = Player.DEFAULT_NAME;
        if (appleIdCredential.fullName != null) {
          print("Apple Name(nick=${appleIdCredential.fullName.nickname}, "
              "given=${appleIdCredential.fullName.givenName}, "
              "middle=${appleIdCredential.fullName.middleName}, "
              "family=${appleIdCredential.fullName.familyName})");
          var nameComponents = appleIdCredential.fullName;
          name = nameComponents.nickname ??
              "${nameComponents.givenName ?? nameComponents.middleName ?? ""} ${nameComponents.familyName ?? ""}";
        }

        final AuthResult _result = await _auth.signInWithCredential(credential);

        return _finishSigningInWithResult(_result, name: name);
        break;
      case AuthorizationStatus.error:
        throw result.error.localizedFailureReason;
        break;
      case AuthorizationStatus.cancelled:
        print("User Cancelled operation");
        throw 'Cancelled';
        break;
      default:
        throw 'Unable to sign in';
    }
  }

  Future<User> _finishSigningInWithResult(AuthResult result, {String name}) async {
    try {
      if (result.user != null) {
        if (name != null && result.user.displayName != name) {
          var updateInfo = UserUpdateInfo();
          updateInfo.displayName = name;
          updateInfo.photoUrl = result.user.photoUrl;
          await result.user.updateProfile(updateInfo);
          await result.user.reload();
          print("Updated user's name to $name");
        }

        // Create the user obj acct in FB
        var userDoc = _userDocument(result.user);

        await userDoc.setData(
            {"name": result.user.displayName, "avatarUrl": result.user.photoUrl, "updatedAt": Timestamp.now()},
            merge: true);

        Logger("UserRepository").fine(
            "Signed-in! User(id=${result.user.uid}, name=${result.user.displayName}, photoUrl=${result.user.photoUrl})");

        // Excellent! Let's create our device
        await PushNotifications().checkAndUpdateToken(force: true);

        return User(
            id: result.user.uid,
            name: result.user.displayName,
            avatarUrl: result.user.photoUrl,
            updatedAt: DateTime.now());
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
    var user = await _auth.currentUser();
    await user.delete();
    await _profilePhotoReference(user).delete();
  }

  DocumentReference _userDocument(FirebaseUser user) {
    return _db.collection(FirebaseConstants.COLLECTION_USERS)
        .document(user.uid);
  }

  StorageReference _profilePhotoReference(FirebaseUser user) {
    return _storage.ref()
        .child(FirebaseConstants.COLLECTION_USERS)
        .child(user.uid);
  }
}
