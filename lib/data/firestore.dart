import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseConstants {
    FirebaseConstants._();

    static const COLLECTION_USERS = "users";
    static const COLLECTION_DEVICES = "devices";
}

class UserNotFoundException { }

Future<bool> isEmailVerified({bool reload = false}) async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    if (currentUser != null) {
        if (reload) {
            await currentUser.reload();
            currentUser = await FirebaseAuth.instance.currentUser();
        }
        return currentUser.isEmailVerified;
    }
    throw UserNotFoundException();
}

Future<void> resendEmailVerification() async {
    final FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    if (currentUser != null) {
        return await currentUser.sendEmailVerification();
    }
    throw UserNotFoundException();
}

Future<T> currentUserOrThrow<T>(Future<T> Function(FirebaseUser user) action) async {
    final FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    if (currentUser != null) {
        return action(currentUser);
    }
    throw UserNotFoundException();
}

Stream<T> streamCurrentUserOrThrow<T>(Stream<T> Function(FirebaseUser user) action) async* {
    final FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    if (currentUser != null) {
        yield* action(currentUser);
    } else {
        throw UserNotFoundException();
    }
}
