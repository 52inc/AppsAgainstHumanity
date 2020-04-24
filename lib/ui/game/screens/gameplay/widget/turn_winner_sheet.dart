import 'package:appsagainsthumanity/data/features/game/model/turn_winner.dart';
import 'package:appsagainsthumanity/internal.dart';
import 'package:appsagainsthumanity/ui/game/screens/gameplay/widget/response_card_view.dart';
import 'package:flutter/material.dart';

class TurnWinnerSheet extends StatelessWidget {
  final TurnWinner turnWinner;

  TurnWinnerSheet(this.turnWinner);

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: SingleChildScrollView(
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
                turnWinner.playerName,
                style: context.theme.textTheme.headline5.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              height: 400,
              margin: const EdgeInsets.only(left: 32, right: 32, top: 24),
              child: buildResponseCardStack(turnWinner.response),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return turnWinner.isRandoCardrissian
        ? CircleAvatar(
            backgroundImage: AssetImage("assets/rando_cardrissian.png"),
            radius: 40,
          )
        : CircleAvatar(
            radius: 40,
            backgroundImage: turnWinner.playerAvatarUrl != null ? NetworkImage(turnWinner.playerAvatarUrl) : null,
            backgroundColor: AppColors.primary,
            child: turnWinner.playerAvatarUrl == null
                ? Text(turnWinner.playerName.split(' ').map((e) => e[0]).join().toUpperCase())
                : null,
          );
  }
}
