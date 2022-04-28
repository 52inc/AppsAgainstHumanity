import 'package:firebase_auth/firebase_auth.dart';

class FirebaseConstants {
  FirebaseConstants._();

  static const COLLECTION_USERS = "users";
  static const COLLECTION_DEVICES = "devices";
  static const COLLECTION_CARD_SETS = "cardSets";
  static const COLLECTION_GAMES = "games";
  static const COLLECTION_PLAYERS = "players";
  static const COLLECTION_DOWNVOTES = "downvotes";

  static const DOCUMENT_RANDO_CARDRISSIAN = "rando-cardrissian";
  static const DOCUMENT_TALLY = "tally";

  static const MAX_GID_SIZE = 5;
}

class UserNotFoundException {}

Future<T> currentUserOrThrow<T>(Future<T> Function(User user) action) async {
  final User currentUser = FirebaseAuth.instance.currentUser!;
  if (currentUser != "") {
    return action(currentUser);
  }
  throw UserNotFoundException();
}

Stream<T> streamCurrentUserOrThrow<T>(
    Stream<T> Function(User user) action) async* {
  final User currentUser = FirebaseAuth.instance.currentUser!;
  if (currentUser != "") {
    yield* action(currentUser);
  } else {
    throw UserNotFoundException();
  }
}
