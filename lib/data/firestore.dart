import 'package:firebase_auth/firebase_auth.dart';

class FirebaseConstants {
    FirebaseConstants._();

    static const COLLECTION_USERS = "users";
    static const COLLECTION_DEVICES = "devices";
    static const COLLECTION_CARD_SETS = "cardSets";
    static const COLLECTION_GAMES = "games";
    static const COLLECTION_PLAYERS = "players";

    static const DOCUMENT_RANDO_CARDRISSIAN = "rando-cardrissian";
}

class UserNotFoundException { }

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

