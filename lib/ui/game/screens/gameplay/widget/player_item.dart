import 'package:appsagainsthumanity/data/features/game/model/player.dart';
import 'package:appsagainsthumanity/data/firestore.dart';
import 'package:appsagainsthumanity/internal.dart';
import 'package:appsagainsthumanity/ui/game/bloc/bloc.dart';
import 'package:appsagainsthumanity/ui/widgets/player_circle_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PlayerItem extends StatelessWidget {
  final Player player;
  final bool isJudge;
  final bool isOwner;
  final bool isSelf;
  final bool isKicking;
  final bool hasDownvoted;

  PlayerItem(
    this.player, {
    this.isJudge = false,
    this.isOwner = false,
    bool isSelf = false,
    this.isKicking = false,
    this.hasDownvoted = false,
  }) : isSelf = isSelf || player.id == FirebaseConstants.DOCUMENT_RANDO_CARDRISSIAN;

  @override
  Widget build(BuildContext context) {
    var playerName = player.name ?? Player.DEFAULT_NAME;
    if (playerName.trim().isEmpty) {
      playerName = Player.DEFAULT_NAME;
    }
    return ListTile(
        contentPadding: EdgeInsets.only(
          left: isOwner ? 8 : 24,
          right: 24,
          top: 4,
          bottom: 4,
        ),
        onTap: () {},
        title: Text(
          playerName,
          style: context.theme.textTheme.subtitle1.copyWith(color: Colors.white),
        ),
        subtitle: isJudge
            ? Text(
                "Judge",
                style: context.theme.textTheme.bodyText2.copyWith(
                  color: AppColors.primaryVariant,
                ),
              )
            : null,
        trailing: Container(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (hasDownvoted)
                Container(
                  margin: const EdgeInsets.only(right: 16),
                  child: Icon(
                    MdiIcons.thumbDown,
                    color: AppColors.primaryVariant,
                  ),
                ),
              Icon(
                MdiIcons.cardsPlayingOutline,
                color: Colors.white70,
              ),
              Container(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  "${player.prizes?.length ?? 0}",
                  style: context.theme.textTheme.subtitle1.copyWith(fontWeight: FontWeight.w600),
                ),
              )
            ],
          ),
        ),
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isOwner)
              Container(
                width: kMinInteractiveDimension,
                height: kMinInteractiveDimension,
                margin: const EdgeInsets.only(right: 8),
                child: isKicking
                    ? Container(
                        padding: const EdgeInsets.all(12),
                        child: CircularProgressIndicator(strokeWidth: 3,),
                      )
                    : Visibility(
                        visible: !isSelf,
                        maintainSize: true,
                        maintainState: true,
                        maintainAnimation: true,
                        child: IconButton(
                          icon: Icon(
                            MdiIcons.karate,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            // Kick Player
                            Analytics().logSelectContent(contentType: 'action', itemId: 'kick_player');
                            context.bloc<GameBloc>().add(KickPlayer(player.id));
                          },
                        ),
                      ),
              ),
            PlayerCircleAvatar(player: player),
          ],
        ));
  }
}
