import 'dart:async';

import 'package:appsagainsthumanity/data/features/cards/model/prompt_special.dart';
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
  StreamSubscription _downvoteSubscription;

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
    } else if (event is DownvotesUpdated) {
      yield* _mapDownvotesUpdatedToState(event);
    } else if (event is StartGame) {
      yield* _mapStartGameToState();
    } else if (event is ClearError) {
      yield* _mapClearErrorToState();
    } else if (event is DownvotePrompt) {
      yield* _mapDownvoteToState();
    } else if (event is PickResponseCard) {
      yield* _mapPickResponseCardToState(event);
    } else if (event is SubmitResponses) {
      yield* _mapSubmitResponsesToState();
    } else if (event is PickWinner) {
      yield* _mapPickWinnerToState(event);
    } else if (event is KickPlayer) {
      yield* _mapKickWinnerToState(event);
    } else if (event is ClearSubmitting) {
      yield* _mapClearSubmittingToState();
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

    _downvoteSubscription?.cancel();
    _downvoteSubscription = gameRepository.observeDownvotes(event.gameId).listen((downvotes) {
      add(DownvotesUpdated(downvotes));
    });
  }

  Stream<GameViewState> _mapUserUpdatedToState(UserUpdated event) async* {
    yield state.copyWith(userId: event.userId);
  }

  Stream<GameViewState> _mapGameUpdatedToState(GameUpdated event) async* {
    yield state.copyWith(game: event.game, isLoading: false, isSubmitting: false);
  }

  Stream<GameViewState> _mapPlayersUpdatedToState(PlayersUpdated event) async* {
    yield state.copyWith(players: event.players, isLoading: false);
  }

  Stream<GameViewState> _mapDownvotesUpdatedToState(DownvotesUpdated event) async* {
    yield state.copyWith(downvotes: event.downvotes, isLoading: false);
  }

  Stream<GameViewState> _mapStartGameToState() async* {
    try {
      yield state.copyWith(isSubmitting: true);
      await gameRepository.startGame(state.game.id);
    } catch (e) {
      if (e is PlatformException) {
        print(e);
        if (e.code == 'functionsError') {
          final Map<String, dynamic> details = Map<String, dynamic>.from(e.details);
          yield state.copyWith(error: details['message'], isSubmitting: false);
        }
      }
    }
  }

  Stream<GameViewState> _mapClearErrorToState() async* {
    yield state.copyWith(error: null);
  }

  Stream<GameViewState> _mapDownvoteToState() async* {
    try {
      await gameRepository.downVoteCurrentPrompt(state.game.id);
    } catch (e) {
      yield state.copyWith(error: "$e");
    }
  }

  Stream<GameViewState> _mapPickResponseCardToState(PickResponseCard event) async* {
    // Check prompt special to determine if we allow the user to pick tow
    var special = promptSpecial(state.game.turn?.promptCard?.special);
    if (special != null) {
      // With a special there is the opportunity to submit more than 1 card. If the user attempts to select more than
      // the allotted amount for a give prompt special, it will clear the selected and set the picked card as the only one
      // effectively starting the selection over.
      var currentSelection = state.selectedCards;
      switch (special) {
        case PromptSpecial.pick2:
          // Selected size limit is 2 here.
          if (currentSelection.length < 2) {
            yield state.copyWith(selectedCards: currentSelection..add(event.card));
          } else {
            yield state.copyWith(selectedCards: [event.card]);
          }
          break;
        case PromptSpecial.draw2pick3:
          // Selected size limit is 3 here. The firebase function that deals with churning-turns will auto-matically
          // deal out an extra 2 cards to the user at turn start
          if (currentSelection.length < 3) {
            yield state.copyWith(selectedCards: currentSelection..add(event.card));
          } else {
            yield state.copyWith(selectedCards: [event.card]);
          }
          break;
      }
    } else {
      // The lack of a special is an indication of PICK 1 only
      yield state.copyWith(selectedCards: [event.card]);
    }
  }

  Stream<GameViewState> _mapSubmitResponsesToState() async* {
    var responses = state.selectedCards;
    if (responses != null && responses.isNotEmpty) {
      try {
        yield state.copyWith(isSubmitting: true);
        await gameRepository.submitResponse(state.game.id, responses);
        yield state.copyWith(selectedCards: [], isSubmitting: false);
      } catch (e) {
        yield state.copyWith(error: "$e", isSubmitting: false);
      }
    }
  }

  Stream<GameViewState> _mapPickWinnerToState(PickWinner event) async* {
    try {
      yield state.copyWith(isSubmitting: true);
      await gameRepository.pickWinner(state.game.id, event.winningPlayerId);
      yield state.copyWith(isSubmitting: false);
    } catch (e) {
      yield state.copyWith(error: "$e", isSubmitting: false);
    }
  }

  Stream<GameViewState> _mapKickWinnerToState(KickPlayer event) async* {
    try {
      yield state.copyWith(kickingPlayerId: event.playerId);
      await gameRepository.kickPlayer(state.game.id, event.playerId);
      yield state.copyWith(kickingPlayerId: null, overrideNull: true);
    } catch (e) {
      yield state.copyWith(error: "$e", kickingPlayerId: null, overrideNull: true);
    }
  }

  Stream<GameViewState> _mapClearSubmittingToState() async* {
    yield state.copyWith(isSubmitting: false);
  }
}
