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
import 'package:cloud_functions/cloud_functions.dart';
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
  Future<Game> findGame(String gid) async {
    var snapshots = await db
        .collection(FirebaseConstants.COLLECTION_GAMES)
        .where('gid', isEqualTo: gid)
        .limit(1)
        .getDocuments();

    if (snapshots != null && snapshots.documents.isNotEmpty) {
      var document = snapshots.documents.first;
      return Game.fromDocument(document);
    } else {
      throw 'Unable to find a game for $gid';
    }
  }

  @override
  Stream<List<UserGame>> observeJoinedGames() {
    return streamCurrentUserOrThrow((firebaseUser) {
      return db
          .collection(FirebaseConstants.COLLECTION_USERS)
          .document(firebaseUser.uid)
          .collection(FirebaseConstants.COLLECTION_GAMES)
          .snapshots()
          .map((querySnapshot) => querySnapshot.documents.map((e) => UserGame.fromDocument(e)).toList());
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
  Future<void> addRandoCardrissian(String gameDocumentId) async {
    var document = db
        .collection(FirebaseConstants.COLLECTION_GAMES)
        .document(gameDocumentId)
        .collection(FirebaseConstants.COLLECTION_PLAYERS)
        .document(FirebaseConstants.DOCUMENT_RANDO_CARDRISSIAN);

    var rando = Player(
      id: FirebaseConstants.DOCUMENT_RANDO_CARDRISSIAN,
      name: "Rando Cardrissian",
      avatarUrl: null,
      isRandoCardrissian: true
    );

    await document.setData(rando.toJson());
  }

  @override
  Future<void> startGame(String gameDocumentId) async {
    final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(functionName: 'startGame');
    dynamic response = await callable.call(<String, dynamic>{
      'game_id': gameDocumentId
    });

    print("Start game Successful! $response");
  }

  @override
  Future<void> submitResponse(String gameDocumentId, List<ResponseCard> cards) {
    // 1. Remove the cards from the player's hand
    // 2. Add the cards as a response to the current game's turn
    return currentUserOrThrow((firebaseUser) async {
      var gameDocument = db
          .collection(FirebaseConstants.COLLECTION_GAMES)
          .document(gameDocumentId);

      var playerDocument = gameDocument
          .collection(FirebaseConstants.COLLECTION_PLAYERS)
          .document(firebaseUser.uid);

      var cardData = cards.map((e) => e.toJson()).toList();

      await db.runTransaction((transaction) async {
        var playerSnapshot = await transaction.get(playerDocument);
        var player = Player.fromDocument(playerSnapshot);

        player.hand.removeWhere((element) {
          return cards.firstWhere((c) => c.cid == element.cid, orElse: () => null) != null;
        });

        await transaction.update(playerDocument, {
          'hand': player.hand.map((e) => e.toJson()).toList()
        });

        await transaction.update(gameDocument, {
          'turn.responses.${firebaseUser.uid}': cardData
        });
      });
    });
  }

  @override
  Future<void> downVoteCurrentPrompt(String gameDocumentId) {
    return currentUserOrThrow((firebaseUser) async {
      var gameDocument = db
          .collection(FirebaseConstants.COLLECTION_GAMES)
          .document(gameDocumentId);

      await gameDocument.updateData({
        'turn.downvotes': FieldValue.arrayUnion([firebaseUser.uid])
      });
    });
  }

  @override
  Future<void> reDealHand(String gameDocumentId) {
    return currentUserOrThrow((firebaseUser) async {
      final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(functionName: 'reDealHand');
      dynamic response = await callable.call(<String, dynamic>{
        'game_id': gameDocumentId
      });

      print("Hand re-dealt successfully! $response");
    });
  }

  @override
  Future<void> pickWinner(String gameDocumentId, String playerId) async {
    final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(functionName: 'pickWinner');
    dynamic response = await callable.call(<String, dynamic>{
      'game_id': gameDocumentId,
      'player_id': playerId
    });

    print("Winner picked Successful! $response");
  }

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
