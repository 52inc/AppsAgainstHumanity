import 'package:appsagainsthumanity/data/app_preferences.dart';
import 'package:appsagainsthumanity/data/features/cards/cards_repository.dart';
import 'package:appsagainsthumanity/data/features/game/game_repository.dart';
import 'package:appsagainsthumanity/ui/creategame/bloc/create_game_event.dart';
import 'package:appsagainsthumanity/ui/creategame/bloc/create_game_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kt_dart/kt.dart';

class CreateGameBloc extends Bloc<CreateGameEvent, CreateGameState> {
  final CardsRepository cardsRepository;
  final GameRepository gameRepository;

  CreateGameBloc(this.cardsRepository, this.gameRepository);

  @override
  CreateGameState get initialState => CreateGameState.empty();

  @override
  Stream<CreateGameState> mapEventToState(CreateGameEvent event) async* {
    if (event is ScreenLoaded) {
      yield* _mapScreenLoadedToState();
    } else if (event is CardSetSelected) {
      yield* _mapCardSetSelectedToState(event);
    } else if (event is CardSourceSelected) {
      yield* _mapCardSourceSelectedToState(event);
    } else if (event is ChangePrizesToWin) {
      yield* _mapChangePrizesToWinToState(event);
    } else if (event is ChangePlayerLimit) {
      yield* _mapChangePlayerLimitToState(event);
    } else if (event is ChangePick2Enabled) {
      yield* _mapChangePick2EnabledToState(event);
    } else if (event is ChangeDraw2Pick3Enabled) {
      yield* _mapChangeDraw2Pick3EnabledToState(event);
    } else if (event is CreateGame) {
      yield* _mapCreateGameToState();
    }
  }

  Stream<CreateGameState> _mapScreenLoadedToState() async* {
    try {
      var cardSets = await cardsRepository.getAvailableCardSets();
      yield state.copyWith(cardSets: cardSets.toImmutableList(), isLoading: false);
    } catch (e) {
      yield state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Stream<CreateGameState> _mapCardSetSelectedToState(CardSetSelected event) async* {
    if (state.selectedSets.contains(event.cardSet)) {
      yield state.copyWith(selectedSets: state.selectedSets.minusElement(event.cardSet).toSet());
    } else {
      yield state.copyWith(selectedSets: state.selectedSets.plusElement(event.cardSet).toSet());
    }
  }

  Stream<CreateGameState> _mapCardSourceSelectedToState(CardSourceSelected event) async* {
    if (event.isAllChecked == null || !event.isAllChecked) {
      // Partial sets are selected, select all
      yield state.copyWith(
        selectedSets: state.selectedSets.plus(
          state.cardSets.filter((cs) => cs.source == event.source)
        ).toSet()
      );
    } else if (event.isAllChecked) {
      // All sets selected, select none
      yield state.copyWith(
        selectedSets: state.selectedSets.filter((s) => s.source != event.source).toSet()
      );
    }
  }

  Stream<CreateGameState> _mapChangePrizesToWinToState(ChangePrizesToWin event) async* {
    AppPreferences().prizesToWin = event.prizesToWin;
    yield state.copyWith(prizesToWin: event.prizesToWin);
  }

  Stream<CreateGameState> _mapChangePlayerLimitToState(ChangePlayerLimit event) async* {
    AppPreferences().playerLimit = event.playerLimit;
    yield state.copyWith(playerLimit: event.playerLimit);
  }

  Stream<CreateGameState> _mapChangePick2EnabledToState(ChangePick2Enabled event) async* {
    yield state.copyWith(pick2Enabled: event.enabled);
  }

  Stream<CreateGameState> _mapChangeDraw2Pick3EnabledToState(ChangeDraw2Pick3Enabled event) async* {
    yield state.copyWith(draw2pick3Enabled: event.enabled);
  }

  Stream<CreateGameState> _mapCreateGameToState() async* {
    yield state.copyWith(isLoading: true, error: null);
    try {
      var game = await gameRepository.createGame(
        state.selectedSets,
        prizesToWin: state.prizesToWin,
        playerLimit: state.playerLimit,
        pick2Enabled: state.pick2Enabled,
        draw2Pick3Enabled: state.draw2pick3Enabled,
      );
      yield state.copyWith(createdGame: game, isLoading: false);
    } catch (e, st) {
      print("Create Game Error: $e\n$st");
      yield state.copyWith(isLoading: false, error: "$e");
    }
  }
}
