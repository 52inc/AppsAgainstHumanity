import 'package:appsagainsthumanity/data/features/game/model/player.dart';
import 'package:appsagainsthumanity/data/features/game/model/turn_winner.dart';
import 'package:appsagainsthumanity/internal.dart';
import 'package:appsagainsthumanity/ui/game/bloc/bloc.dart';
import 'package:appsagainsthumanity/ui/game/screens/gameplay/widget/winning/other_responses_pager.dart';
import 'package:appsagainsthumanity/ui/game/screens/gameplay/widget/winning/prompt_card_view.dart';
import 'package:appsagainsthumanity/ui/game/screens/gameplay/widget/response_card_view.dart';
import 'package:appsagainsthumanity/ui/widgets/player_circle_avatar.dart';
import 'package:flutter/material.dart';

class TurnWinnerSheet extends StatelessWidget {
  final GameViewState state;
  final TurnWinner turnWinner;
  final ScrollController scrollController;

  TurnWinnerSheet(this.state, this.scrollController) : turnWinner = state.game.turn.winner;

  @override
  Widget build(BuildContext context) {
    var playerName = turnWinner.playerName ?? Player.DEFAULT_NAME;
    if (playerName.trim().isEmpty) {
      playerName = Player.DEFAULT_NAME;
    }
    return SizedBox.expand(
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: Text(
                "Winner!",
                style: context.theme.textTheme.headline3.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              child: _buildAvatar(context),
            ),
            Container(
              margin: const EdgeInsets.only(top: 16),
              child: Text(
                playerName,
                style: context.theme.textTheme.headline5.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              height: 850,
              margin: const EdgeInsets.only(top: 24),
              child: PromptCardView(
                state: state,
                margin: const EdgeInsets.symmetric(horizontal: 32),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 32),
                  child: buildResponseCardStack(
                    turnWinner.response,
                    lastChild: Column(
                      children: [
                        Divider(),
                        Container(
                          margin: const EdgeInsets.only(top: 8, left: 20),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Player Responses".toUpperCase(),
                            style: context.theme.textTheme.subtitle2.copyWith(
                              color: AppColors.primaryVariant,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(top: 16),
                            child: OtherResponsesPager(
                              turnWinner.playerId,
                              state.game.round - 1,
                              turnWinner.responses,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return PlayerCircleAvatar(
      radius: 40,
      player: Player(
        id: turnWinner.playerId,
        name: turnWinner.playerName,
        avatarUrl: turnWinner.playerAvatarUrl,
        isRandoCardrissian: turnWinner.isRandoCardrissian,
      ),
    );
  }
}
