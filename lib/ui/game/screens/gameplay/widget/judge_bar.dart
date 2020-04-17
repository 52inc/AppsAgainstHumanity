import 'package:appsagainsthumanity/data/features/game/model/player.dart';
import 'package:appsagainsthumanity/internal.dart';
import 'package:appsagainsthumanity/ui/game/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class JudgeBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameViewState>(
      builder: (context, state) {
        var judge = state.currentJudge;
        var isWinner = state.game.turn?.winnerId != null && state.game.turn?.winnerId == judge?.id;
        if (judge != null) {
          return _buildHeader(context, judge, isWinner: isWinner);
        } else {
          return Container(height: 72);
        }
      },
    );
  }

  Widget _buildHeader(BuildContext context, Player player, {bool isWinner = false}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      title: Text(player.name),
      subtitle: isWinner
          ? Text("Winner!", style: context.theme.textTheme.bodyText1.copyWith(color: AppColors.secondary))
          : Text("Current judge", style: context.theme.textTheme.bodyText2.copyWith(color: Colors.white60)),
      leading: isWinner ? _buildWinnerAvatar(context, player) : _buildJudgeAvatar(context, player),
      trailing: !isWinner
          ? IconButton(
              icon: Icon(
                Icons.thumb_down,
                color: Colors.white,
              ),
              onPressed: () {
                context.bloc<GameBloc>().add(DownvotePrompt());
              },
            )
          : null,
    );
  }

  Widget _buildWinnerAvatar(BuildContext context, Player player) {
    return Container(
      width: 52,
      padding: const EdgeInsets.only(top: 4),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 12, right: 0, top: 4, bottom: 0),
            child: _buildCircleAvatar(context, player),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
              child: Icon(MdiIcons.crown, color: Colors.black87, size: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJudgeAvatar(BuildContext context, Player player) {
      return Container(
          width: 52,
          padding: const EdgeInsets.only(left: 12),
          child: _buildCircleAvatar(context, player),
      );
  }

  Widget _buildCircleAvatar(BuildContext context, Player player) {
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
