import 'dart:math';
import 'package:appsagainsthumanity/data/features/cards/model/card_set.dart';
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
import 'package:flutter/services.dart';
import 'package:kt_dart/kt.dart';

class FirestoreGameRepository extends GameRepository {
  final FirebaseFirestore db;
  final UserRepository userRepository;

  FirestoreGameRepository({FirebaseFirestore firestore, UserRepository userRepository})
      : assert(userRepository != null),
        userRepository = userRepository,
        db = firestore ?? FirebaseFirestore.instance;

  @override
  Future<Game> createGame(
    KtSet<CardSet> cardSets, {
    int prizesToWin = Game.PRIZES_TO_WIN,
    int playerLimit = Game.PLAYER_LIMIT,
    bool pick2Enabled = true,
    bool draw2Pick3Enabled = true,
  }) {
    return currentUserOrThrow((firebaseUser) async {
      var newGameDoc = db.collection(FirebaseConstants.COLLECTION_GAMES).doc();
      var game = Game(
        id: newGameDoc.id,
        gid: generateId(length: FirebaseConstants.MAX_GID_SIZE),
        ownerId: firebaseUser.uid,
        state: GameState.waitingRoom,
        prizesToWin: prizesToWin,
        playerLimit: playerLimit,
        pick2Enabled: pick2Enabled,
        draw2Pick3Enabled: draw2Pick3Enabled,
        cardSets: cardSets.map((c) => c.id).asList().toSet(),
      );
      await newGameDoc.set(game.toJson());

      // Now add yourself as a player to the game
      await _addSelfToGame(gameDocumentId: newGameDoc.id);

      return game;
    });
  }

  @override
  Future<Game> joinGame(String gid) {
    return currentUserOrThrow((firebaseUser) async {
      return await _addSelfToGame(gid: gid);
    });
  }

  @override
  Future<Game> findGame(String gid) async {
    var snapshots =
        await db.collection(FirebaseConstants.COLLECTION_GAMES)
            .where('gid', isEqualTo: gid.toUpperCase())
            .limit(1)
            .get();

    if (snapshots != null && snapshots.docs.isNotEmpty) {
      var document = snapshots.docs.first;
      return Game.fromDocument(document);
    } else {
      throw 'Unable to find a game for $gid';
    }
  }

  @override
  Future<Game> getGame(String gameDocumentId, {bool andJoin = false}) async {
    var gameDocument = db.collection(FirebaseConstants.COLLECTION_GAMES)
        .doc(gameDocumentId);

    try {
      var snapshot = await gameDocument.get();
      return Game.fromDocument(snapshot);
    } catch (e) {
      if (e is PlatformException && andJoin) {
        try {
          return await _addSelfToGame(gameDocumentId: gameDocumentId);
        } catch (e, st) {
          print("Error joining game: $e\n$st");
        }
      }
    }

    return null;
  }

  @override
  Future<void> leaveGame(UserGame game) {
    return currentUserOrThrow((firebaseUser) async {
      if (game.state == GameState.completed) {
        // We should just delete the usergame ourselfs
        await db.collection(FirebaseConstants.COLLECTION_USERS)
            .doc(firebaseUser.uid)
            .collection(FirebaseConstants.COLLECTION_GAMES)
            .doc(game.id)
            .delete();
        print("Game already completed, so we just deleted the reference");
      } else {
        final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('leaveGame');
        HttpsCallableResult response = await callable.call(<String, dynamic>{
          'game_id': game.id
        });
        print("Game left! ${response.data}");
      }
    });
  }

  @override
  Stream<List<UserGame>> observeJoinedGames() {
    return streamCurrentUserOrThrow((firebaseUser) {
      return db
          .collection(FirebaseConstants.COLLECTION_USERS)
          .doc(firebaseUser.uid)
          .collection(FirebaseConstants.COLLECTION_GAMES)
          .snapshots()
          .map((querySnapshot) => querySnapshot.docs.map((e) => UserGame.fromDocument(e)).toList());
    });
  }

  @override
  Stream<Game> observeGame(String gameDocumentId) {
    var document = db.collection(FirebaseConstants.COLLECTION_GAMES).doc(gameDocumentId);

    return document.snapshots().map((snapshot) => Game.fromDocument(snapshot));
  }

  @override
  Stream<List<Player>> observePlayers(String gameDocumentId) {
    var collection = db
        .collection(FirebaseConstants.COLLECTION_GAMES)
        .doc(gameDocumentId)
        .collection(FirebaseConstants.COLLECTION_PLAYERS);

    return collection.snapshots().map((snapshots) => snapshots.docs.map((e) => Player.fromDocument(e)).toList());
  }

  @override
  Stream<List<String>> observeDownvotes(String gameDocumentId) {
    var collection = db
        .collection(FirebaseConstants.COLLECTION_GAMES)
        .doc(gameDocumentId)
        .collection(FirebaseConstants.COLLECTION_DOWNVOTES)
        .doc(FirebaseConstants.DOCUMENT_TALLY);

    return collection.snapshots().map((snapshot) {
      if (snapshot.data != null) {
        final data = snapshot.data() ?? {};
        print(data);
        print("Contains votes: ${data.containsKey('votes')}");
        print("Votes: ${data['votes']}");
        return List<String>.from(data['votes'] ?? []);
      } else {
        return [];
      }
    });
  }

  @override
  Future<void> addRandoCardrissian(String gameDocumentId) async {
    var document = db
        .collection(FirebaseConstants.COLLECTION_GAMES)
        .doc(gameDocumentId)
        .collection(FirebaseConstants.COLLECTION_PLAYERS)
        .doc(FirebaseConstants.DOCUMENT_RANDO_CARDRISSIAN);

    var rando = Player(
        id: FirebaseConstants.DOCUMENT_RANDO_CARDRISSIAN,
        name: "Rando Cardrissian",
        avatarUrl: null,
        isRandoCardrissian: true);

    await document.set(rando.toJson());
  }

  @override
  Future<void> startGame(String gameDocumentId) async {
    final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('startGame');
    dynamic response = await callable.call(<String, dynamic>{'game_id': gameDocumentId});
    print("Start game Successful! $response");
  }

  @override
  Future<void> submitResponse(String gameDocumentId, List<ResponseCard> cards) async {
    final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('submitResponses');
    dynamic response = await callable.call(<String, dynamic>{
      'game_id': gameDocumentId,
      'indexed_responses': cards.asMap().map((key, value) => MapEntry(key.toString(), value.cid))
    });
    print("Responses Submitted! $response");
  }

  @override
  Future<void> downVoteCurrentPrompt(String gameDocumentId) {
    return currentUserOrThrow((firebaseUser) async {
      var gameDocument = db
          .collection(FirebaseConstants.COLLECTION_GAMES)
          .doc(gameDocumentId)
          .collection(FirebaseConstants.COLLECTION_DOWNVOTES)
          .doc(FirebaseConstants.DOCUMENT_TALLY);

      var snapshot = await gameDocument.get();
      if (snapshot.exists) {
        await gameDocument.update({
          'votes': FieldValue.arrayUnion([firebaseUser.uid])
        });
      } else {
        await gameDocument.set({
          'votes': [firebaseUser.uid]
        });
      }
    });
  }

  @override
  Future<void> waveAtPlayer(String gameDocumentId, String playerId, [String message]) {
    return currentUserOrThrow((firebaseUser) async {
      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('wave');
      dynamic response = await callable.call(<String, dynamic>{
        'game_id': gameDocumentId,
        'player_id': playerId,
        if (message != null)
          'message': message,
      });
      print("Wave sent to player successfully! $response");
    });
  }

  @override
  Future<void> reDealHand(String gameDocumentId) {
    return currentUserOrThrow((firebaseUser) async {
      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('reDealHand');
      dynamic response = await callable.call(<String, dynamic>{'game_id': gameDocumentId});
      print("Hand re-dealt successfully! $response");
    });
  }

  @override
  Future<void> pickWinner(String gameDocumentId, String playerId) async {
    final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('pickWinner');
    dynamic response = await callable.call(<String, dynamic>{'game_id': gameDocumentId, 'player_id': playerId});
    print("Winner picked Successful! $response");
  }

  Future<Game> _addSelfToGame({String gameDocumentId, String gid}) async {
    var user = await userRepository.getUser();

    final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('joinGame');
    HttpsCallableResult response = await callable.call(<String, dynamic>{
      if (gameDocumentId != null)
        'game_id': gameDocumentId,

      if (gid != null)
        'gid': gid.toUpperCase(),

      'name': user.name,
      'avatar': user.avatarUrl
    });

    var jsonResponse = Map<String, dynamic>.from(response.data);
    var game = Game.fromJson(jsonResponse);
    game.id = jsonResponse['id'];
    return game;
  }

  @override
  Future<void> kickPlayer(String gameDocumentId, String playerId) async {
    final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('kickPlayer');
    HttpsCallableResult response = await callable.call(<String, dynamic>{
      'game_id': gameDocumentId,
      'player_id': playerId
    });
    print("Player kicked! ${response.data}");
  }

  String generateId({int length = 7}) {
    String source = "ACEFHJKLMNPQRTUVWXY3479";
    StringBuffer builder = StringBuffer();
    for (var i = 0; i < length; i++) {
      builder.write(source[Random().nextInt(source.length)]);
    }
    return builder.toString();
  }
}
