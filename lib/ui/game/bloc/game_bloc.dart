import 'dart:async';

import 'package:appsagainsthumanity/data/features/game/game_repository.dart';
import 'package:appsagainsthumanity/data/features/game/model/game.dart';
import 'package:appsagainsthumanity/ui/game/bloc/game_event.dart';
import 'package:appsagainsthumanity/ui/game/bloc/game_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

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
    } else if (event is GameUpdated) {
      yield* _mapGameUpdatedToState(event);
    } else if (event is PlayersUpdated) {
      yield* _mapPlayersUpdatedToState(event);
    }
  }

  Stream<GameViewState> _mapSubscribeToState(Subscribe event) async* {
    var user = await FirebaseAuth.instance.currentUser();
    yield state.copyWith(userId: user.uid);

    _gameSubscription?.cancel();
    _gameSubscription = gameRepository.observeGame(event.gameId).listen((game) {
      add(GameUpdated(game));
    });
    
    _playersSubscription?.cancel();
    _playersSubscription = gameRepository.observePlayers(event.gameId).listen((players) { 
      add(PlayersUpdated(players));
    });
  }

  Stream<GameViewState> _mapGameUpdatedToState(GameUpdated event) async* {
    yield state.copyWith(game: event.game, isLoading: false);
  }

  Stream<GameViewState> _mapPlayersUpdatedToState(PlayersUpdated event) async* {
    yield state.copyWith(players: event.players, isLoading: false);
  }
}
