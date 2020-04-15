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
