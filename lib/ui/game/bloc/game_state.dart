import 'package:appsagainsthumanity/data/features/cards/model/prompt_special.dart';
import 'package:appsagainsthumanity/data/features/cards/model/response_card.dart';
import 'package:appsagainsthumanity/data/features/game/model/game.dart';
import 'package:appsagainsthumanity/data/features/game/model/player.dart';
import 'package:meta/meta.dart';

@immutable
class GameViewState {
  /* FIELDS */
  final String userId;
  final Game game;
  final List<Player> players;
  final List<ResponseCard> selectedCards;
  final List<String> downvotes;
  final bool isSubmitting;
  final String kickingPlayerId;
  final bool isLoading;
  final String error;

  /* PROPERTIES */
  bool get isOurGame => userId == game?.ownerId;

  Player get currentJudge => players?.firstWhere((p) => p.id == game.turn?.judgeId);
  Player get lastJudge => players?.firstWhere((p) => !(game.turn?.winner?.responses?.containsKey(p.id) ?? true));

  /// Get the current prompt card text with any macros computed from the text string. For now this is just
  /// the a simple replace of the judge's name for its specific replacer text.
  /// TODO: Extract this into a tool that can take a configurable macro list for smart injecting text into prompts
  String get currentPromptText {
    var prompt = game.turn?.promptCard;
    var judge = currentJudge;
    if (judge != null && prompt != null) {
      return prompt.text.replaceAll("{JUDGE_NAME}", judge.name);
    } else if (prompt != null) {
      return prompt.text;
    } else {
      return "";
    }
  }

  /// Get the current prompt card text with any macros computed from the text string. For now this is just
  /// the a simple replace of the judge's name for its specific replacer text.
  /// TODO: Extract this into a tool that can take a configurable macro list for smart injecting text into prompts
  String get lastPromptText {
    var prompt = game.turn?.winner?.promptCard;
    var judge = lastJudge;
    if (judge != null && prompt != null) {
      return prompt.text.replaceAll("{JUDGE_NAME}", judge.name);
    } else if (prompt != null) {
      return prompt.text;
    } else {
      return "";
    }
  }

  Player get currentPlayer => players?.firstWhere((p) => p.id == userId);

  Player get winner => players?.firstWhere((p) => p.id == game.winner);

  List<ResponseCard> get currentHand => currentPlayer?.hand?.where((c) => !selectedCards.contains(c))?.toList() ?? [];

  bool get areWeJudge => currentJudge?.id == userId;

  bool get haveWeSubmittedResponse => game.turn?.responses?.keys?.contains(userId) ?? false;

  bool get allResponsesSubmitted {
    if (game.turn != null && game.turn.responses != null && players != null && players.isNotEmpty) {
      var allPlayersExcludingJudgeAndInactive =
          players.where((element) => element.id != game.turn.judgeId && element.isInactive != true).toList();
      for (var value in allPlayersExcludingJudgeAndInactive) {
        if (game.turn.responses.keys.firstWhere((element) => element == value.id, orElse: () => null) == null) {
          return false;
        }
      }
      return true;
    } else {
      return false;
    }
  }

  bool get selectCardsMeetPromptRequirement {
    PromptSpecial special = promptSpecial(game.turn?.promptCard?.special);
    if (special != null) {
      if (special == PromptSpecial.pick2) {
        return selectedCards.length == 2;
      } else if (special == PromptSpecial.draw2pick3) {
        return selectedCards.length == 3;
      }
    } else {
      return selectedCards.isNotEmpty;
    }
    return false;
  }

  GameViewState({
    this.userId,
    this.game,
    this.players,
    List<String> downvotes,
    List<ResponseCard> selectedCards,
    this.isSubmitting = false,
    this.isLoading = true,
    this.kickingPlayerId,
    this.error,
  }) : selectedCards = selectedCards ?? [],
        downvotes = downvotes;

  GameViewState copyWith({
    String userId,
    Game game,
    List<Player> players,
    List<ResponseCard> selectedCards,
    List<String> downvotes,
    bool isSubmitting,
    bool isLoading,
    String kickingPlayerId,
    String error,
    bool overrideNull = false
  }) {
    return GameViewState(
      userId: userId ?? this.userId,
      game: game ?? this.game,
      players: players ?? this.players,
      downvotes: downvotes ?? this.downvotes,
      selectedCards: selectedCards ?? this.selectedCards,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isLoading: isLoading ?? this.isLoading,
      kickingPlayerId: overrideNull ? kickingPlayerId : kickingPlayerId ?? this.kickingPlayerId,
      error: overrideNull ? error : error ?? this.error,
    );
  }

  @override
  String toString() {
    return '''GameViewState { 
          userId: $userId,
          game: ${game?.gid},
          turn: ${game?.turn?.winner}, 
          players: ${players?.length}, 
          downvotes: $downvotes,
          selectedCards: $selectedCards,
          isSubmitting: $isSubmitting,
          isLoading: $isLoading, 
          kickingPlayerId: $kickingPlayerId,
          error: $error,
          isOurGame: $isOurGame,
        }''';
  }
}
