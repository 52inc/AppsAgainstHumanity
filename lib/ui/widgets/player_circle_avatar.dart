import 'package:appsagainsthumanity/data/features/game/model/player.dart';
import 'package:appsagainsthumanity/internal.dart';
import 'package:flutter/material.dart';

class PlayerCircleAvatar extends StatelessWidget {
  final Player player;
  final double radius;

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
                ? player.name != null ? Text(player.name.split(' ').map((e) => e[0]).join().toUpperCase()) : null
                : null,
          );
  }
}
