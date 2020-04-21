import 'dart:async';
import 'package:appsagainsthumanity/data/features/cards/model/response_card.dart';
import 'package:appsagainsthumanity/data/features/game/model/game.dart';
import 'package:appsagainsthumanity/data/features/game/model/game_state.dart';
import 'package:appsagainsthumanity/data/features/game/model/player.dart';
import 'package:appsagainsthumanity/data/features/users/model/user_game.dart';
import 'package:kt_dart/collection.dart';

abstract class GameRepository {

    /// Create a new game with the provided list of card sets
    Future<Game> createGame(KtSet<String> cardSets, { int prizesToWin = 10 });

    /// Join an existing game using the [gid] game id code
    Future<Game> joinGame(String gid);

    /// Find an existing game using the [gid] game id code
    Future<Game> findGame(String gid);

    /// Return a list of games that you have joined in the past
    Stream<List<UserGame>> observeJoinedGames();

    /// Observe any changes to a game state by it's [gameDocumentId]
    Stream<Game> observeGame(String gameDocumentId);

    /// Observe any changes to the players of a game by it's
    /// [gameDocumentId]
    Stream<List<Player>> observePlayers(String gameDocumentId);

    /// Add Rando Cardrissian to the game
    /// [gid] the game to add him to
    Future<void> addRandoCardrissian(String gameDocumentId);

    /// Start a game that is in it's [GameState.waitingRoom] state
    /// The gamescreen should pick up the game state change and update the UI
    /// accordingly
    Future<void> startGame(String gameDocumentId);

    /// Submit your responses for the current turn, if you are not a judge, and
    /// you haven't submitted your response already
    Future<void> submitResponse(String gameDocumentId, List<ResponseCard> cards);

    /// Downvote the current prompt card. If enough downvotes are casted
    /// then a new prompt is drawn for this turn and the current judge remains
    Future<void> downVoteCurrentPrompt(String gameDocumentId);

    //////////////////////
    // Judge Methods
    //////////////////////

    /// Pick the winner of the turn that you are judging. This will fail if:
    /// A. You are not the judge
    /// B. All responses are not in yet
    /// C. The turn hasn't been rotated yet and your previous pick still persists
    Future<void> pickWinner(String gameDocumentId, String playerId);
}
