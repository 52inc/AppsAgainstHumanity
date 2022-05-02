import 'dart:async';

import 'package:appsagainsthumanity/data/features/game/game_repository.dart';
import 'package:appsagainsthumanity/data/features/users/user_repository.dart';
import 'package:appsagainsthumanity/ui/home/bloc/home_event.dart';
import 'package:appsagainsthumanity/ui/home/bloc/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  UserRepository? _userRepository;
  GameRepository? _gameRepository;
  StreamSubscription? _userSubscription;
  StreamSubscription? _joinedGamesSubscription;

  HomeBloc({
    UserRepository? userRepository,
    GameRepository? gameRepository,
    StreamSubscription? userSubscription,
    StreamSubscription? joinedGameSubscription,
  })  : _userRepository = userRepository,
        _gameRepository = gameRepository,
        _userSubscription = userSubscription,
        _joinedGamesSubscription = joinedGameSubscription,
        super(
          HomeState(
            // user: User(),
            isLoading: false,
          ),
        ) {}

  @override
  HomeState get initialState => HomeState.loading();

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is HomeStarted) {
      yield* _mapHomeStartedToState();
    } else if (event is JoinedGamesUpdated) {
      yield* _mapJoinedGamesUpdatedToState(event);
    } else if (event is UserUpdated) {
      yield* _mapUserUpdatedToState(event);
    } else if (event is LeaveGame) {
      yield* _mapLeaveGameToState(event);
    } else if (event is JoinGame) {
      yield* _mapJoinGameToState(event);
    }
  }

  Stream<HomeState> _mapHomeStartedToState() async* {
    try {
      _userSubscription?.cancel();
      _userSubscription = _userRepository?.observeUser().listen((user) {
        add(UserUpdated(user));
      });

      _joinedGamesSubscription?.cancel();
      _joinedGamesSubscription =
          _gameRepository?.observeJoinedGames().listen((event) {
        add(JoinedGamesUpdated(event));
      });
    } catch (e, stacktrace) {
      Logger("HomeBloc").fine("Error loading user && games", e, stacktrace);
      yield state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Stream<HomeState> _mapJoinedGamesUpdatedToState(
      JoinedGamesUpdated event) async* {
    yield state.copyWith(
        games: event.games..sort((a, b) => b.joinedAt.compareTo(a.joinedAt)));
  }

  Stream<HomeState> _mapUserUpdatedToState(UserUpdated event) async* {
    yield state.copyWith(user: event.user, isLoading: false);
  }

  Stream<HomeState> _mapLeaveGameToState(LeaveGame event) async* {
    try {
      yield state.copyWith(
          leavingGame: event.game, games: state.games?..remove(event.game));
      await _gameRepository?.leaveGame(event.game);
      yield state.copyWith(leavingGame: null);
    } catch (e) {
      yield state.copyWith(leavingGame: null, error: "$e");
    }
  }

  Stream<HomeState> _mapJoinGameToState(JoinGame event) async* {
    try {
      yield state.copyWith(joiningGame: event.gameCode);
      var game = await _gameRepository?.joinGame(event.gameCode);
      yield state.copyWith(
          joiningGame: null, joinedGame: game, overrideNull: true);
    } catch (e) {
      yield state.copyWith(
          joiningGame: null, joinedGame: null, error: "$e", overrideNull: true);
    }
  }
}
