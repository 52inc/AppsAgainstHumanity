import 'package:kt_dart/kt.dart';
import 'package:meta/meta.dart';

@immutable
class CreateGameState {
  final KtList<String> cardSets;
  final KtSet<String> selectedSets;
  final bool isLoading;
  final String error;

  CreateGameState({
    @required this.cardSets,
    @required this.selectedSets,
    @required this.isLoading,
    this.error,
  });

  factory CreateGameState.loading({Set<String> sets}) {
    return CreateGameState(
      cardSets: emptyList(),
      selectedSets: sets.toImmutableSet() ?? emptySet(),
      isLoading: true,
    );
  }

  CreateGameState copyWith({
    KtList<String> cardSets,
    KtSet<String> selectedSets,
    bool isLoading,
    String error,
  }) {
    return CreateGameState(
      cardSets: cardSets ?? this.cardSets,
      selectedSets: selectedSets ?? this.selectedSets,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  String toString() {
    return '''CreateGameState { 
      cardSets: $cardSets, 
      selectedSets: $selectedSets,
      isLoading: $isLoading, 
      error: $error
    }''';
  }
}
