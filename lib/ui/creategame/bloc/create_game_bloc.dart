import 'package:appsagainsthumanity/data/features/cards/cards_repository.dart';
import 'package:appsagainsthumanity/data/features/game/game_repository.dart';
import 'package:appsagainsthumanity/ui/creategame/bloc/create_game_event.dart';
import 'package:appsagainsthumanity/ui/creategame/bloc/create_game_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kt_dart/kt.dart';

class CreateGameBloc extends Bloc<CreateGameEvent, CreateGameState> {
  final Set<String> cardSets;
  final CardsRepository cardsRepository;
  final GameRepository gameRepository;

  CreateGameBloc(this.cardSets, this.cardsRepository, this.gameRepository,);

  @override
  CreateGameState get initialState => CreateGameState.loading(sets: cardSets);

  @override
  Stream<CreateGameState> mapEventToState(CreateGameEvent event) async* {
    if (event is ScreenLoaded) {
      yield* _mapScreenLoadedToState();
    } else if (event is CardSetSelected) {
      yield* _mapCardSetSelectedToState(event);
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
}
