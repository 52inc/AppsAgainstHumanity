import 'dart:math';

import 'package:appsagainsthumanity/data/features/cards/model/response_card.dart';
import 'package:appsagainsthumanity/data/features/game/game_repository.dart';
import 'package:appsagainsthumanity/data/features/game/model/game.dart';
import 'package:appsagainsthumanity/data/features/game/model/game_state.dart';
import 'package:appsagainsthumanity/data/features/game/model/player.dart';
import 'package:appsagainsthumanity/data/features/users/model/user_game.dart';
import 'package:appsagainsthumanity/data/features/users/user_repository.dart';
import 'package:appsagainsthumanity/data/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kt_dart/kt.dart';

class FirestoreGameRepository extends GameRepository {
  final Firestore db;
  final UserRepository userRepository;

  FirestoreGameRepository({Firestore firestore, UserRepository userRepository})
      : assert(userRepository != null),
        userRepository = userRepository,
        db = firestore ?? Firestore.instance;

  @override
  Future<Game> createGame(KtSet<String> cardSets, {int prizesToWin = 10}) {
    return currentUserOrThrow((firebaseUser) async {
      var newGameDoc = db.collection(FirebaseConstants.COLLECTION_GAMES).document();

      var game = Game(
        id: newGameDoc.documentID,
        gid: generateId(),
        ownerId: firebaseUser.uid,
        state: GameState.waitingRoom,
        prizesToWin: prizesToWin,
        cardSets: cardSets.asSet(),
      );
      await newGameDoc.setData(game.toJson());

      // Now add yourself as a player to the game
      await _addSelfToGame(newGameDoc.documentID, game);

      return game;
    });
  }

  @override
  Future<Game> joinGame(String gid) {
    return currentUserOrThrow((firebaseUser) async {
      var snapshot =
          await db.collection(FirebaseConstants.COLLECTION_GAMES).where('gid', isEqualTo: gid).limit(1).getDocuments();

      if (snapshot != null && snapshot.documents.isNotEmpty) {
        var gameDocument = snapshot.documents.first;
        var game = Game.fromDocument(gameDocument);

        // Only let user's join a game that hasn't been started yet
        if (game.state == GameState.waitingRoom) {
          await _addSelfToGame(gameDocument.documentID, game);
          return game;
        } else {
          throw 'You cannot join a game that is already in-progress or completed';
        }
      } else {
        throw 'No game found for $gid';
      }
    });
  }

  @override
  Future<List<UserGame>> getJoinedGames() {
    return currentUserOrThrow((firebaseUser) async {
      var games = await db.collection(FirebaseConstants.COLLECTION_USERS)
          .document(firebaseUser.uid)
          .collection(FirebaseConstants.COLLECTION_GAMES)
          .getDocuments();

      return games.documents.map((document) => UserGame.fromDocument(document)).toList();
    });
  }

  @override
  Stream<Game> observeGame(String gameDocumentId) {
    var document = db.collection(FirebaseConstants.COLLECTION_GAMES).document(gameDocumentId);

    return document.snapshots().map((snapshot) => Game.fromDocument(snapshot));
  }

  @override
  Stream<List<Player>> observePlayers(String gameDocumentId) {
    var collection = db
        .collection(FirebaseConstants.COLLECTION_GAMES)
        .document(gameDocumentId)
        .collection(FirebaseConstants.COLLECTION_PLAYERS);

    return collection.snapshots().map((snapshots) => snapshots.documents.map((e) => Player.fromDocument(e)).toList());
  }

  @override
  Future<Function> submitResponse(List<ResponseCard> cards) {}

  @override
  Future<Function> downVoteCurrentPrompt() {}

  @override
  Future<Function> pickWinner(String playerId) {}

  Future<void> _addSelfToGame(String gameDocumentId, Game game) async {
    var user = await userRepository.getUser();
    var player = Player(
      id: user.id,
      name: user.name,
      avatarUrl: user.avatarUrl,
    );

    // Write self to game's players
    await db
        .collection(FirebaseConstants.COLLECTION_GAMES)
        .document(gameDocumentId)
        .collection(FirebaseConstants.COLLECTION_PLAYERS)
        .document(user.id)
        .setData(player.toJson(), merge: true);

    // Write game to your collection of games
    var userGame = UserGame(
      gid: game.gid,
      state: game.state,
      joinedAt: DateTime.now(),
    );
    await db
        .collection(FirebaseConstants.COLLECTION_USERS)
        .document(user.id)
        .collection(FirebaseConstants.COLLECTION_GAMES)
        .document(gameDocumentId)
        .setData(userGame.toJson());
  }

  String generateId({int length = 5}) {
    String source = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    StringBuffer builder = StringBuffer();
    for (var i = 0; i < length; i++) {
      builder.write(source[Random().nextInt(source.length)]);
    }
    return builder.toString();
  }
}
