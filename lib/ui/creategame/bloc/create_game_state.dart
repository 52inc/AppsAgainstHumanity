import 'package:appsagainsthumanity/data/app_preferences.dart';
import 'package:appsagainsthumanity/data/features/cards/model/card_set.dart';
import 'package:kt_dart/kt.dart';
import 'package:meta/meta.dart';

@immutable
class CreateGameState {
  final KtList<CardSet> cardSets;
  final KtSet<CardSet> selectedSets;
  final int prizesToWin;
  final int playerLimit;
  final bool pick2Enabled;
  final bool draw2pick3Enabled;

  final bool isLoading;
  final String error;

  CreateGameState({
    @required this.cardSets,
    @required this.selectedSets,
    @required this.isLoading,
    this.error,
    this.prizesToWin = 7,
    this.playerLimit = 15,
    this.pick2Enabled = true,
    this.draw2pick3Enabled = true
  });

  factory CreateGameState.empty() {
    return CreateGameState(
      cardSets: emptyList(),
      selectedSets: emptySet(),
      prizesToWin: AppPreferences().prizesToWin,
      playerLimit: AppPreferences().playerLimit,
      isLoading: true,
    );
  }

  CreateGameState copyWith({
    KtList<CardSet> cardSets,
    KtSet<CardSet> selectedSets,
    int prizesToWin,
    int playerLimit,
    bool pick2Enabled,
    bool draw2pick3Enabled,
    bool isLoading,
    String error,
  }) {
    return CreateGameState(
      cardSets: cardSets ?? this.cardSets,
      selectedSets: selectedSets ?? this.selectedSets,
      prizesToWin: prizesToWin ?? this.prizesToWin,
      playerLimit: playerLimit ?? this.playerLimit,
      pick2Enabled: pick2Enabled ?? this.pick2Enabled,
      draw2pick3Enabled: draw2pick3Enabled ?? this.draw2pick3Enabled,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  String toString() {
    return '''CreateGameState { 
      cardSets: $cardSets, 
      selectedSets: $selectedSets, 
      prizesToWin: $prizesToWin, 
      playerLimit: $playerLimit, 
      pick2Enabled: $pick2Enabled, 
      draw2pick3Enabled: $draw2pick3Enabled, 
      isLoading: $isLoading, 
      error: $error
    }''';
  }
}
