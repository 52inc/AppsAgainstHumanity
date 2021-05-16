import 'package:appsagainsthumanity/data/features/game/game_repository.dart';
import 'package:appsagainsthumanity/data/features/game/model/game_state.dart';
import 'package:appsagainsthumanity/data/features/users/model/user_game.dart';
import 'package:appsagainsthumanity/ui/home/bloc/bloc.dart';
import 'package:appsagainsthumanity/internal.dart';
import 'package:appsagainsthumanity/ui/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

class PastGame extends StatelessWidget {
  final UserGame game;
  final bool isLeavingGame;

  PastGame(this.game, this.isLeavingGame);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(game.id),
      child: _buildListTile(context),
      direction: DismissDirection.horizontal,
      background: _buildBackground(context),
      confirmDismiss: (_) => confirmDismiss(context),
      onDismissed: (direction) {
        Analytics().logSelectContent(contentType: 'past_game', itemId: 'leave');
        context.bloc<HomeBloc>().add(LeaveGame(game));
      },
    );
  }

  Widget _buildListTile(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      title: Text(
        game.gid,
        style: context.theme.textTheme.subtitle1.copyWith(
          color: AppColors.primaryVariant,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        isLeavingGame ? "Leaving..." : game.state.label,
        style: context.theme.textTheme.bodyText2.copyWith(
          color: Colors.white60,
        ),
      ),
      trailing: isLeavingGame
          ? Container(width: 24, height: 24, child: CircularProgressIndicator())
          : Text(
              timeago.format(game.joinedAt),
              style: context.theme.textTheme.bodyText2.copyWith(
                color: Colors.white54,
              ),
            ),
      onTap: game.state == GameState.inProgress ||
              game.state == GameState.waitingRoom
          ? () => openGame(context)
          : null,
    );
  }

  Widget _buildBackground(BuildContext context) {
    return Container(
      color: Colors.redAccent[200],
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 16),
            child: Icon(
              MdiIcons.deleteEmpty,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Container(),
          ),
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: Icon(
              MdiIcons.deleteEmpty,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void openGame(BuildContext context) async {
    Analytics().logSelectContent(contentType: 'past_game', itemId: 'open');
    try {
      var existingGame =
          await context.repository<GameRepository>().getGame(game.id);
      Navigator.of(context).push(GamePageRoute(existingGame));
    } catch (e) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text("$e"),
        ));
    }
  }

  Future<bool> confirmDismiss(BuildContext context) {
    return showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text("Leave game?"),
            content:
                Text("Are you sure you want to leave the game ${game.gid}?"),
            actions: [
              TextButton(
                child: Text("CANCEL"),
                style: TextButton.styleFrom(
                  primary: AppColors.primaryVariant,
                ),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              TextButton(
                child: Text("LEAVE"),
                style: TextButton.styleFrom(
                  primary: AppColors.primaryVariant,
                ),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          );
        });
  }
}
