import 'package:appsagainsthumanity/data/features/users/model/user.dart';
import 'package:appsagainsthumanity/data/features/users/model/user_game.dart';
import 'package:meta/meta.dart';

@immutable
class HomeState {
  final User user;
  final List<UserGame> games;
  final String error;
  final bool isLoading;

  HomeState({
    @required this.user,
    @required this.isLoading,
    List<UserGame> games,
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
    bool isLoading,
    String error,
  }) {
    return HomeState(
      user: user ?? this.user,
      games: games ?? this.games,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  String toString() {
    return '''HomeState {
      user: $user,
      games: $games,
      isLoading: $isLoading,
      error: $error
    }''';
  }
}
