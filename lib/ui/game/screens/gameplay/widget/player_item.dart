import 'package:appsagainsthumanity/data/features/game/model/player.dart';
import 'package:appsagainsthumanity/internal.dart';
import 'package:appsagainsthumanity/ui/widgets/player_circle_avatar.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PlayerItem extends StatelessWidget {
  final Player player;
  final bool isJudge;
  final bool hasDownvoted;

  PlayerItem(this.player, {this.isJudge = false, this.hasDownvoted = false});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
        onTap: () {},
        title: Text(
          player.name ?? Player.DEFAULT_NAME,
          style: context.theme.textTheme.subtitle1.copyWith(color: Colors.white),
        ),
        subtitle: isJudge
            ? Text(
                "Judge",
                style: context.theme.textTheme.bodyText2.copyWith(
                  color: AppColors.secondary,
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
                    color: AppColors.secondary,
                  ),
                ),
              Icon(MdiIcons.cardsPlayingOutline),
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
        leading: PlayerCircleAvatar(player: player));
  }
}
