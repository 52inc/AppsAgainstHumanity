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
import 'package:kt_dart/kt.dart';

class FirestoreGameRepository extends GameRepository {
  final Firestore db;
  final UserRepository userRepository;

  FirestoreGameRepository({Firestore firestore, UserRepository userRepository})
      : assert(userRepository != null),
        userRepository = userRepository,
        db = firestore ?? Firestore.instance;

  @override
  Future<Game> createGame(
    KtSet<CardSet> cardSets, {
    int prizesToWin = Game.PRIZES_TO_WIN,
    int playerLimit = Game.PLAYER_LIMIT,
    bool pick2Enabled = true,
    bool draw2Pick3Enabled = true,
  }) {
    return currentUserOrThrow((firebaseUser) async {
      var newGameDoc = db.collection(FirebaseConstants.COLLECTION_GAMES).document();
      var game = Game(
        id: newGameDoc.documentID,
        gid: generateId(length: FirebaseConstants.MAX_GID_SIZE),
        ownerId: firebaseUser.uid,
        state: GameState.waitingRoom,
        prizesToWin: prizesToWin,
        playerLimit: playerLimit,
        pick2Enabled: pick2Enabled,
        draw2Pick3Enabled: draw2Pick3Enabled,
        cardSets: cardSets.map((c) => c.id).asList().toSet(),
      );
      await newGameDoc.setData(game.toJson());

      // Now add yourself as a player to the game
      await _addSelfToGame(gameDocumentId: newGameDoc.documentID);

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
        await db.collection(FirebaseConstants.COLLECTION_GAMES).where('gid', isEqualTo: gid).limit(1).getDocuments();

    if (snapshots != null && snapshots.documents.isNotEmpty) {
      var document = snapshots.documents.first;
      return Game.fromDocument(document);
    } else {
      throw 'Unable to find a game for $gid';
    }
  }

  @override
  Future<Game> getGame(String gameDocumentId, {bool andJoin = false}) async {
    var gameDocument = db.collection(FirebaseConstants.COLLECTION_GAMES).document(gameDocumentId);

    var snapshot = await gameDocument.get();
    var game = Game.fromDocument(snapshot);

    if (andJoin) {
      try {
        game = await _addSelfToGame(gameDocumentId: gameDocumentId);
      } catch (e, st) {
        print("Error joining game: $e\n$st");
      }
    } else if (andJoin) {
      throw 'You cannot join a game that has already started';
    }

    return game;
  }

  @override
  Future<void> leaveGame(String gameDocumentId) {
    return currentUserOrThrow((firebaseUser) async {
      // Flag player object as inactive in the game

      // remove from judging order

      // remove any responses

      // Delete UserGame obj
    });
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
  Stream<List<String>> observeDownvotes(String gameDocumentId) {
    var collection = db
        .collection(FirebaseConstants.COLLECTION_GAMES)
        .document(gameDocumentId)
        .collection(FirebaseConstants.COLLECTION_DOWNVOTES)
        .document(FirebaseConstants.DOCUMENT_TALLY);

    return collection.snapshots().map((snapshot) {
      if (snapshot.data != null) {
        return List<String>.from(snapshot.data['votes'] ?? []);
      } else {
        return [];
      }
    });
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
        isRandoCardrissian: true);

    await document.setData(rando.toJson());
  }

  @override
  Future<void> startGame(String gameDocumentId) async {
    final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(functionName: 'startGame');
    dynamic response = await callable.call(<String, dynamic>{'game_id': gameDocumentId});
    print("Start game Successful! $response");
  }

  @override
  Future<void> submitResponse(String gameDocumentId, List<ResponseCard> cards) async {
    final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(functionName: 'submitResponses');
    dynamic response = await callable.call(<String, dynamic>{
      'game_id': gameDocumentId,
      'responses': cards.map((e) => e.cid).toList()
    });
    print("Responses Submitted! $response");
  }

  @override
  Future<void> downVoteCurrentPrompt(String gameDocumentId) {
    return currentUserOrThrow((firebaseUser) async {
      var gameDocument = db
          .collection(FirebaseConstants.COLLECTION_GAMES)
          .document(gameDocumentId)
          .collection(FirebaseConstants.COLLECTION_DOWNVOTES)
          .document(FirebaseConstants.DOCUMENT_TALLY);

      var snapshot = await gameDocument.get();
      if (snapshot.exists) {
        await gameDocument.updateData({
          'votes': FieldValue.arrayUnion([firebaseUser.uid])
        });
      } else {
        await gameDocument.setData({
          'votes': [firebaseUser.uid]
        });
      }
    });
  }

  @override
  Future<void> reDealHand(String gameDocumentId) {
    return currentUserOrThrow((firebaseUser) async {
      final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(functionName: 'reDealHand');
      dynamic response = await callable.call(<String, dynamic>{'game_id': gameDocumentId});
      print("Hand re-dealt successfully! $response");
    });
  }

  @override
  Future<void> pickWinner(String gameDocumentId, String playerId) async {
    final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(functionName: 'pickWinner');
    dynamic response = await callable.call(<String, dynamic>{'game_id': gameDocumentId, 'player_id': playerId});
    print("Winner picked Successful! $response");
  }

  Future<Game> _addSelfToGame({String gameDocumentId, String gid}) async {
    var user = await userRepository.getUser();

    final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(functionName: 'joinGame');
    HttpsCallableResult response = await callable.call(<String, dynamic>{
      if (gameDocumentId != null)
        'game_id': gameDocumentId,

      if (gid != null)
        'gid': gid,

      'name': user.name,
      'avatar': user.avatarUrl
    });

    var jsonResponse = Map<String, dynamic>.from(response.data);
    var game = Game.fromJson(jsonResponse);
    game.id = jsonResponse['id'];
    return game;
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
