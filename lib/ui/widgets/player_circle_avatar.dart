import 'package:appsagainsthumanity/data/features/game/model/player.dart';
import 'package:appsagainsthumanity/internal.dart';
import 'package:flutter/material.dart';

class PlayerCircleAvatar extends StatelessWidget {
  final Player player;
  final double radius;

  String get playerInitials {
    var splitName = player.name.split(' ');
    if (splitName != null && splitName.isNotEmpty) {
      var nonEmptyCharacters = splitName.where((e) => e.isNotEmpty);
      if (nonEmptyCharacters.isNotEmpty) {
        return nonEmptyCharacters.map((e) => e[0]).join().toUpperCase();
      } else {
        return "";
      }
    } else {
      return "";
    }
  }

  PlayerCircleAvatar({@required this.player, this.radius = 20});

  @override
  Widget build(BuildContext context) {
    return player.isRandoCardrissian
        ? CircleAvatar(
            backgroundImage: AssetImage("assets/rando_cardrissian.png"),
            radius: radius,
          )
        : CircleAvatar(
            radius: this.radius,
            backgroundImage: player.avatarUrl != null ? NetworkImage(player.avatarUrl) : null,
            backgroundColor: AppColors.primary,
            child: player.avatarUrl == null
                ? player.name != null
                    ? Text(
                        playerInitials,
                        style: context.theme.textTheme.subtitle1.copyWith(
                          color: Colors.white,
                        ),
                      )
                    : null
                : null,
          );
  }
}
