import 'package:appsagainsthumanity/data/features/game/model/game.dart';
import 'package:appsagainsthumanity/data/features/users/model/user.dart';
import 'package:appsagainsthumanity/data/features/users/model/user_game.dart';
import 'package:meta/meta.dart';

@immutable
class HomeState {
  final User user;
  final List<UserGame> games;
  final UserGame leavingGame;
  final String joiningGame;
  final Game joinedGame;
  final String error;
  final bool isLoading;

  HomeState({
    @required this.user,
    @required this.isLoading,
    List<UserGame> games,
    this.leavingGame,
    this.joiningGame,
    this.joinedGame,
    this.error,
  }) : games = games ?? [];

  factory HomeState.loading() {
    return HomeState(
      user: null,
      isLoading: true,
      error: null,
    );
  }

  HomeState copyWith({
    User user,
    List<UserGame> games,
    UserGame leavingGame,
    String joiningGame,
    Game joinedGame,
    bool isLoading,
    String error,
    bool overrideNull = false
  }) {
    return HomeState(
      user: user ?? this.user,
      games: games ?? this.games,
      leavingGame: overrideNull ? leavingGame : leavingGame ?? this.leavingGame,
      joiningGame: overrideNull ? joiningGame : joiningGame ?? this.joiningGame,
      joinedGame: overrideNull ? joinedGame : joinedGame ?? this.joinedGame,
      isLoading: isLoading ?? this.isLoading,
      error: overrideNull ? error : error ?? this.error,
    );
  }

  @override
  String toString() {
    return '''HomeState {
      user: $user,
      games: $games,
      isLoading: $isLoading,
      leavingGame: $leavingGame,
      joiningGame: $joiningGame,
      joinedGame: $joinedGame,
      error: $error
    }''';
  }
}
