import 'dart:async';

import 'package:appsagainsthumanity/data/features/game/game_repository.dart';
import 'package:appsagainsthumanity/data/features/users/user_repository.dart';
import 'package:appsagainsthumanity/ui/home/bloc/home_event.dart';
import 'package:appsagainsthumanity/ui/home/bloc/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  UserRepository _userRepository;
  GameRepository _gameRepository;
  StreamSubscription _joinedGamesSubscription;

  HomeBloc(this._userRepository, this._gameRepository);

  @override
  HomeState get initialState => HomeState.loading();

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is HomeStarted) {
      yield* _mapHomeStartedToState();
    } else if (event is JoinedGamesUpdated){
      yield* _mapJoinedGamesUpdatedToState(event);
    }
  }

  Stream<HomeState> _mapHomeStartedToState() async* {
    try {
      var user = await _userRepository.getUser();
      yield state.copyWith(isLoading: false, user: user);

      _joinedGamesSubscription?.cancel();
      _joinedGamesSubscription = _gameRepository.observeJoinedGames().listen((event) {
        add(JoinedGamesUpdated(event));
      });
    } catch (e, stacktrace) {
      Logger("HomeBloc").fine("Error loading user && games", e, stacktrace);
      yield state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Stream<HomeState> _mapJoinedGamesUpdatedToState(JoinedGamesUpdated event) async* {
    yield state.copyWith(games: event.games..sort((a, b) => b.joinedAt.compareTo(a.joinedAt)));
  }
}
