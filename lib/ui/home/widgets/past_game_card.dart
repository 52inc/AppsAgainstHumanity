import 'dart:io';
import 'package:appsagainsthumanity/data/features/game/game_repository.dart';
import 'package:appsagainsthumanity/data/features/game/model/game_state.dart';
import 'package:appsagainsthumanity/data/features/users/model/user_game.dart';
import 'package:appsagainsthumanity/ui/home/bloc/bloc.dart';
import 'package:appsagainsthumanity/internal.dart';
import 'package:appsagainsthumanity/ui/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;

class PastGamesCard extends StatelessWidget {
  final HomeState state;

  PastGamesCard(this.state);

  @override
  Widget build(BuildContext context) {
    var topMargin = MediaQuery.of(context).padding.top + (Platform.isAndroid ? 24 : 0);
    return Container(
      margin: EdgeInsets.only(left: 8, right: 8, top: topMargin),
      child: AspectRatio(
        aspectRatio: 312 / 436,
        child: Material(
          elevation: 4.0,
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                margin: const EdgeInsets.all(24),
                child: Text(
                  "Past Games",
                  style: context.theme.textTheme.headline3
                      .copyWith(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 48),
                ),
              ),
              Divider(
                height: 1,
                color: Colors.black12,
              ),
              Expanded(
                child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: state.games.length,
                    itemBuilder: (context, index) {
                      var game = state.games[index];
                      var isLeavingGame = game.id == state.leavingGame?.id;
                      return PastGame(game, isLeavingGame);
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  void openGame(BuildContext context, String gid) async {
    // Fetch and load game
    try {
      var existingGame = await context.repository<GameRepository>().findGame(gid);
      Navigator.of(context).push(GamePageRoute(existingGame));
    } catch (e) {
      Scaffold.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text("$e"),
        ));
    }
  }
}

class PastGame extends StatelessWidget {
  final UserGame game;
  final bool isLeavingGame;

  PastGame(this.game, this.isLeavingGame);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        game.gid,
        style: context.theme.textTheme.subtitle1.copyWith(color: AppColors.primary, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        isLeavingGame ? "Leaving..." : game.state.label,
        style: context.theme.textTheme.bodyText2.copyWith(color: Colors.black54),
      ),
      trailing: isLeavingGame
          ? Container(width: 24, height: 24,child: CircularProgressIndicator())
          : Text(
              timeago.format(game.joinedAt),
              style: context.theme.textTheme.bodyText2.copyWith(color: Colors.black26),
            ),
      onTap: game.state == GameState.inProgress || game.state == GameState.waitingRoom ? () => openGame(context) : null,
      onLongPress: () => leaveGame(context),
    );
  }

  void openGame(BuildContext context) async {
    try {
      var existingGame = await context.repository<GameRepository>().getGame(game.id);
      Navigator.of(context).push(GamePageRoute(existingGame));
    } catch (e) {
      Scaffold.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text("$e"),
        ));
    }
  }

  void leaveGame(BuildContext context) async {
    var result = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text("Leave game?"),
            content: Text("Are you sure you want to leave the game ${game.gid}?"),
            actions: [
              FlatButton(
                child: Text("CANCEL"),
                textColor: AppColors.primaryVariant,
                onPressed: () => Navigator.of(context).pop(false),
              ),
              FlatButton(
                child: Text("LEAVE"),
                textColor: AppColors.primaryVariant,
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          );
        });

    if (result == true) {
      context.bloc<HomeBloc>().add(LeaveGame(game));
    }
  }
}
