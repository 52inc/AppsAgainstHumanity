import 'package:appsagainsthumanity/data/features/game/model/player.dart';
import 'package:appsagainsthumanity/ui/game/bloc/bloc.dart';
import 'package:appsagainsthumanity/ui/widgets/player_circle_avatar.dart';
import 'package:appsagainsthumanity/internal.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class WaitingPlayerResponses extends StatelessWidget {
  final GameViewState state;

  WaitingPlayerResponses(this.state);

  @override
  Widget build(BuildContext context) {
    var players = state.players?.where((element) {
      return element.id != state.game.turn?.judgeId && element.isInactive != true;
    })?.toList() ?? [];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: <Widget>[
          Divider(height: 1, color: Colors.white38),
          Expanded(
            child: GridView.builder(
                padding: const EdgeInsets.only(left: 12, right: 12, top: 8),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 88 / 130,
                ),
                itemCount: players.length,
                itemBuilder: (context, index) {
                  var player = players[index];
                  var hasSubmittedResponse = state.game.turn?.responses?.containsKey(player.id) ?? false;
                  return PlayerResponseCard(player, hasSubmittedResponse);
                }),
          ),
        ],
      ),
    );
  }
}

class PlayerResponseCard extends StatelessWidget {
  final Player player;
  final bool hasSubmittedResponse;

  PlayerResponseCard(this.player, this.hasSubmittedResponse);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: Material(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        elevation: 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 16),
              child: PlayerCircleAvatar(player: player),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 8, left: 8, right: 8),
                child: Text(
                  player.name,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.theme.textTheme.bodyText2.copyWith(
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.topCenter,
                child: hasSubmittedResponse
                    ? Icon(
                        MdiIcons.checkboxMarkedCircleOutline,
                        color: AppColors.primary,
                        size: 32,
                      )
                    : Icon(
                        MdiIcons.checkboxBlankCircleOutline,
                        color: Colors.black54,
                        size: 32,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
