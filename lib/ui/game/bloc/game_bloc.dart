import 'dart:async';

import 'package:appsagainsthumanity/data/features/game/game_repository.dart';
import 'package:appsagainsthumanity/data/features/game/model/game.dart';
import 'package:appsagainsthumanity/ui/game/bloc/game_event.dart';
import 'package:appsagainsthumanity/ui/game/bloc/game_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameBloc extends Bloc<GameEvent, GameViewState> {
  final Game initialGame;
  final GameRepository gameRepository;

  StreamSubscription _gameSubscription;
  StreamSubscription _playersSubscription;

  GameBloc(this.initialGame, this.gameRepository);

  @override
  GameViewState get initialState => GameViewState(game: initialGame);

  @override
  Stream<GameViewState> mapEventToState(GameEvent event) async* {
    if (event is Subscribe) {
      yield* _mapSubscribeToState(event);
    } else if (event is UserUpdated) {
      yield* _mapUserUpdatedToState(event);
    } else if (event is GameUpdated) {
      yield* _mapGameUpdatedToState(event);
    } else if (event is PlayersUpdated) {
      yield* _mapPlayersUpdatedToState(event);
    } else if (event is StartGame) {
      yield* _mapStartGameToState();
    } else if (event is ClearError) {
      yield* _mapClearErrorToState();
    }
  }

  Stream<GameViewState> _mapSubscribeToState(Subscribe event) async* {
    var user = await FirebaseAuth.instance.currentUser();
    add(UserUpdated(user.uid));

    _gameSubscription?.cancel();
    _gameSubscription = gameRepository.observeGame(event.gameId).listen((game) {
      add(GameUpdated(game));
    });
    
    _playersSubscription?.cancel();
    _playersSubscription = gameRepository.observePlayers(event.gameId).listen((players) { 
      add(PlayersUpdated(players));
    });
  }

  Stream<GameViewState> _mapUserUpdatedToState(UserUpdated event) async* {
    yield state.copyWith(userId: event.userId);
  }

  Stream<GameViewState> _mapGameUpdatedToState(GameUpdated event) async* {
    yield state.copyWith(game: event.game, isLoading: false);
  }

  Stream<GameViewState> _mapPlayersUpdatedToState(PlayersUpdated event) async* {
    yield state.copyWith(players: event.players, isLoading: false);
  }

  Stream<GameViewState> _mapStartGameToState() async* {
    try {
      await gameRepository.startGame(state.game.id);
    } catch (e) {
      if (e is PlatformException) {
        print(e);
        if (e.code == 'functionsError') {
          final Map<String, dynamic> details = Map<String, dynamic>.from(e.details);
          yield state.copyWith(error: details['message']);
        }
      }
    }
  }

  Stream<GameViewState> _mapClearErrorToState() async* {
    yield state.copyWith(error: null);
  }
}
