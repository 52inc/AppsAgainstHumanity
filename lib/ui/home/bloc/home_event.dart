import 'package:appsagainsthumanity/data/features/users/model/user.dart';
import 'package:appsagainsthumanity/data/features/users/model/user_game.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class HomeStarted extends HomeEvent {}

@immutable
class JoinedGamesUpdated extends HomeEvent {
  final List<UserGame> games;

  JoinedGamesUpdated(this.games);

  @override
  List<Object> get props => [games];
}

@immutable
class UserUpdated extends HomeEvent {
  final User user;

  UserUpdated(this.user);

  @override
  List<Object> get props => [user];
}
