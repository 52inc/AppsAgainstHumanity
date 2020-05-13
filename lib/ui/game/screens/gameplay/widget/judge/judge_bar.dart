import 'package:appsagainsthumanity/data/features/game/model/player.dart';
import 'package:appsagainsthumanity/internal.dart';
import 'package:appsagainsthumanity/ui/game/bloc/bloc.dart';
import 'package:appsagainsthumanity/ui/widgets/player_circle_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class JudgeBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameViewState>(
      builder: (context, state) {
        var judge = state.currentJudge;
        var hasDownvoted = state.downvotes?.contains(state.userId) ?? false;
        if (judge != null) {
          return _buildHeader(
            context,
            judge,
            hasDownvoted: hasDownvoted,
          );
        } else {
          return Container(height: 72);
        }
      },
    );
  }

  Widget _buildHeader(BuildContext context, Player player, {bool hasDownvoted = false}) {
    var playerName = player.name ?? Player.DEFAULT_NAME;
    if (playerName.trim().isEmpty) {
      playerName = Player.DEFAULT_NAME;
    }
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      title: Text(playerName),
      subtitle: Text("Current judge", style: context.theme.textTheme.bodyText2.copyWith(color: Colors.white60)),
      leading: _buildJudgeAvatar(context, player),
      trailing: IconButton(
        icon: Icon(
          hasDownvoted ? MdiIcons.thumbDown : MdiIcons.thumbDownOutline,
          color: hasDownvoted ? AppColors.primary : Colors.white,
        ),
        onPressed: !hasDownvoted
            ? () {
                Analytics().logSelectContent(contentType: 'action', itemId: 'downvote');
                context.bloc<GameBloc>().add(DownvotePrompt());
              }
            : null,
      ),
    );
  }

  Widget _buildJudgeAvatar(BuildContext context, Player player) {
    return Container(
      width: 52,
      padding: const EdgeInsets.only(left: 12),
      child: PlayerCircleAvatar(player: player),
    );
  }
}
