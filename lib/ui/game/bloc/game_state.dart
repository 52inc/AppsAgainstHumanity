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

    final bool isLoading;
    final String error;


    /* PROPERTIES */
    bool get isOurGame => userId == game?.ownerId;
    Player get currentJudge => players.firstWhere((p) => p.id == game.turn?.judgeId);

    GameViewState({
        this.userId,
        this.game,
        this.players,
        this.selectedCards,
        this.isLoading = true,
        this.error,
    });

    GameViewState copyWith({
        String userId,
        Game game,
        List<Player> players,
        List<ResponseCard> selectedCards,
        bool isLoading,
        String error,
    }) {
        return GameViewState(
            userId: userId ?? this.userId,
            game: game ?? this.game,
            players: players ?? this.players,
            selectedCards: selectedCards ?? this.selectedCards,
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
          isLoading: $isLoading, 
          error: $error,
          isOurGame: $isOurGame,
        }''';
    }
}
