import 'package:appsagainsthumanity/data/features/game/model/player.dart';
import 'package:appsagainsthumanity/internal.dart';
import 'package:flutter/material.dart';

class PlayerCircleAvatar extends StatelessWidget {
  final Player player;

  PlayerCircleAvatar({@required this.player});

  @override
  Widget build(BuildContext context) {
    return player.isRandoCardrissian
        ? CircleAvatar(backgroundImage: AssetImage("assets/rando_cardrissian.png"))
        : CircleAvatar(
            radius: 20,
            backgroundImage: player.avatarUrl != null ? NetworkImage(player.avatarUrl) : null,
            backgroundColor: AppColors.primary,
            child: player.avatarUrl == null ? Text(player.name.split(' ').map((e) => e[0]).join().toUpperCase()) : null,
          );
  }
}
