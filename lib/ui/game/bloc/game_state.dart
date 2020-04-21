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
    final bool isSubmitting;
    final bool isLoading;
    final String error;

    /* PROPERTIES */
    bool get isOurGame => userId == game?.ownerId;

    Player get currentJudge => players?.firstWhere((p) => p.id == game.turn?.judgeId);

    Player get currentPlayer => players?.firstWhere((p) => p.id == userId);

    Player get winner => players?.firstWhere((p) => p.id == game.winner);

    List<ResponseCard> get currentHand => currentPlayer?.hand?.where((c) => !selectedCards.contains(c))?.toList() ?? [];

    bool get areWeJudge => currentJudge?.id == userId;

    bool get haveWeSubmittedResponse => game.turn?.responses?.keys?.contains(userId) ?? false;

    bool get allResponsesSubmitted {
        if (game.turn != null && game.turn.responses != null && players != null && players.isNotEmpty) {
            var allPlayersExcludingJudge = players.where((element) => element.id != game.turn.judgeId).toList();
            for (var value in allPlayersExcludingJudge) {
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
        List<ResponseCard> selectedCards,
        this.isSubmitting = false,
        this.isLoading = true,
        this.error,
    }) : selectedCards = selectedCards ?? [];

    GameViewState copyWith({
        String userId,
        Game game,
        List<Player> players,
        List<ResponseCard> selectedCards,
        bool isSubmitting,
        bool isLoading,
        String error,
    }) {
        return GameViewState(
            userId: userId ?? this.userId,
            game: game ?? this.game,
            players: players ?? this.players,
            selectedCards: selectedCards ?? this.selectedCards,
            isSubmitting: isSubmitting ?? this.isSubmitting,
            isLoading: isLoading ?? this.isLoading,
            error: error ?? this.error,
        );
    }

    @override
    String toString() {
        return '''GameViewState { 
          userId: $userId,
          game: ${game?.gid}, 
          players: $players, 
          selectedCards: $selectedCards,
          isSubmitting: $isSubmitting,
          isLoading: $isLoading, 
          error: $error,
          isOurGame: $isOurGame,
        }''';
    }
}
