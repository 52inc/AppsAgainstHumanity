import 'package:appsagainsthumanity/data/features/game/model/game.dart';
import 'package:appsagainsthumanity/data/features/game/model/player.dart';
import 'package:meta/meta.dart';

@immutable
class GameViewState {
  final String userId;
  final Game game;
  final List<Player> players;
  final bool isLoading;
  final String error;

  bool get isOurGame => userId == game.ownerId;

  GameViewState({
    this.userId,
    @required this.game,
    @required this.players,
    this.isLoading = true,
    this.error,
  });

  GameViewState copyWith({
    String userId,
    Game game,
    List<Player> players,
    bool isLoading,
    String error,
  }) {
    return GameViewState(
      userId: userId ?? this.userId,
      game: game ?? this.game,
      players: players ?? this.players,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  String toString() {
    return '''GameState { 
      game: $game, 
      players: $players, 
      isLoading: $isLoading, 
      error: $error
    }''';
  }
}
