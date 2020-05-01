import 'package:appsagainsthumanity/data/features/cards/model/response_card.dart';
import 'package:appsagainsthumanity/data/features/game/model/game.dart';
import 'package:appsagainsthumanity/data/features/game/model/player.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object> get props => [];
}

/// This event get's triggered on bloc creation so that we can start subscribing
/// to changes to the game and player state in firebase
@immutable
class Subscribe extends GameEvent {
  final String gameId;

  Subscribe(this.gameId);

  @override
  List<Object> get props => [gameId];
}

class StartGame extends GameEvent {}
class ClearError extends GameEvent {}

/// This event is triggered to update the user id in the game state
@immutable
class UserUpdated extends GameEvent {
  final String userId;

  UserUpdated(this.userId);

  @override
  List<Object> get props => [userId];
}

/// This event is triggered whenever the game object get's update or is loaded
@immutable
class GameUpdated extends GameEvent {
  final Game game;

  GameUpdated(this.game);

  @override
  List<Object> get props => [game];
}

/// This event is triggered whenever the players of this game get updated
@immutable
class PlayersUpdated extends GameEvent {
  final List<Player> players;

  PlayersUpdated(this.players);

  @override
  List<Object> get props => [players];
}

@immutable
class DownvotesUpdated extends GameEvent {
  final List<String> downvotes;

  DownvotesUpdated(this.downvotes);

  @override
  List<Object> get props => [downvotes];
}

class DownvotePrompt extends GameEvent { }

@immutable
class PickResponseCard extends GameEvent {
  final ResponseCard card;

  PickResponseCard(this.card);

  @override
  List<Object> get props => [card];
}

@immutable
class PickWinner extends GameEvent {
  final String winningPlayerId;

  PickWinner(this.winningPlayerId);

  @override
  List<Object> get props => [winningPlayerId];
}

@immutable
class KickPlayer extends GameEvent {
  final String playerId;

  KickPlayer(this.playerId);

  @override
  List<Object> get props => [playerId];
}

class SubmitResponses extends GameEvent { }

class ClearSubmitting extends GameEvent { }
