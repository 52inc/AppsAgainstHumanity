import 'package:appsagainsthumanity/data/features/game/game_repository.dart';
import 'package:appsagainsthumanity/data/features/game/model/player.dart';
import 'package:appsagainsthumanity/internal.dart';
import 'package:appsagainsthumanity/internal/dynamic_links.dart';
import 'package:appsagainsthumanity/ui/game/bloc/bloc.dart';
import 'package:appsagainsthumanity/ui/widgets/player_circle_avatar.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:share/share.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class WaitingRoomScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameViewState>(
      bloc: context.read<GameBloc>(),
      builder: (context, state) {
        return _buildScaffold(context, state);
      },
    );
  }

  Widget _buildScaffold(BuildContext context, GameViewState state) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
        ),
        // brightness: Brightness.dark,
        // textTheme: context.theme.textTheme,
        iconTheme: context.theme.iconTheme,
        title: Text("Waiting for players"),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(72),
          child: Container(
            height: 72,
            padding: const EdgeInsets.only(bottom: 8),
            alignment: Alignment.center,
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 72),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Game ID",
                        style: context.theme.textTheme.bodyText1?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                      Text(
                        state.game!.gid,
                        style: context.theme.textTheme.headline4?.copyWith(
                          color: context.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 16, top: 4),
                        child: OutlinedButton(
                          child: Text("INVITE"),
                          style: OutlinedButton.styleFrom(
                              primary: context.primaryColor,
                              textStyle:
                                  context.theme.textTheme.button?.copyWith(
                                color: context.primaryColor,
                              ),
                              side: BorderSide(color: context.primaryColor),
                              padding: const EdgeInsets.all(16)),
                          // highlightedBorderColor: context.primaryColor,
                          // splashColor: context.primaryColor.withOpacity(0.40),
                          onPressed: () async {
                            Analytics().logShare(
                                contentType: 'game',
                                itemId: 'invite',
                                method: 'dynamic_link');
                            var link =
                                await DynamicLinks.createLink(state.game!.id!);
                            _shareLink(context, link.toString());
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
//        actions: [
//          IconButton(
//            icon: Icon(Icons.group_add),
//            onPressed: () async {
//              var link = await DynamicLinks.createLink(state.game.id);
//              await Share.share(link.toString());
//            },
//          )
//        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: state.isOurGame
          ? FloatingActionButton.extended(
              icon: Icon(MdiIcons.play),
              label: Text("START GAME"),
              backgroundColor: AppColors.primary,
              onPressed: () async {
                Analytics().logSelectContent(
                    contentType: 'action', itemId: 'start_game');
                context.read<GameBloc>().add(StartGame());
              })
          : null,
      body: BlocListener<GameBloc, GameViewState>(
        bloc: context.read<GameBloc>(),
        listener: (context, state) {
          if (state.error != null) {
            context.scaffold
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.error!),
                  backgroundColor: AppColors.primary,
                ),
              );
          }
        },
        child: _buildPlayerList(context, state),
      ),
    );
  }

  /// Build the player list which is the only component in this particular tree
  /// that needs to update to the change in game state
  Widget _buildPlayerList(BuildContext context, GameViewState state) {
    var players = state.players ?? [];
    var hasRandoBeenInvitedOrNotOwner =
        (state.players?.any((element) => element.isRandoCardrissian) ??
                false) ||
            !state.isOurGame;
    return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount:
            hasRandoBeenInvitedOrNotOwner ? players.length : players.length + 1,
        itemBuilder: (context, index) {
          if (index < players.length) {
            var player = players[index];
            return _buildPlayerTile(context, player, index);
          } else {
            return _buildRandoCardrissianInvite(context, state.game!.id!);
          }
        });
  }

  Widget _buildPlayerTile(BuildContext context, Player player, int index) {
    var playerName = player.name == "" ? Player.DEFAULT_NAME : "";
    if (playerName.trim().isEmpty) {
      playerName = Player.DEFAULT_NAME;
    }
    return ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
        onTap: () {},
        title: Text(
          playerName,
          style:
              context.theme.textTheme.subtitle1?.copyWith(color: Colors.white),
        ),
        leading: PlayerCircleAvatar(player: player));
  }

  Widget _buildRandoCardrissianInvite(
      BuildContext context, String gameDocumentId) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      title: Text(
        "Invite Rando Cardrissian?",
        style: context.theme.textTheme.subtitle1?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: CircleAvatar(
        backgroundImage: AssetImage("assets/rando_cardrissian.png"),
      ),
      trailing: Icon(MdiIcons.robot, color: Colors.white),
      onTap: () async {
        Analytics().logSelectContent(
            contentType: 'players', itemId: 'invite_rando_cardrissian');
        await context
            .read<GameRepository>()
            .addRandoCardrissian(gameDocumentId);
      },
    );
  }

  void _shareLink(BuildContext context, String link) async {
    if (kIsWeb) {
      // await shareWeb(link);
      await FlutterClipboard.copy(link);
      context.scaffold.showSnackBar(SnackBar(
        content: Text("Link copied to clipboard!"),
      ));
    } else {
      await Share.share(link.toString());
    }
  }

  Future<void> shareWeb(String linkToShare) async {
    if (!kIsWeb) {
      throw UnimplementedError('Share is only implemented on Web');
    }

    // final html.HtmlDocument doc = js.context['document'];
    // final html.AnchorElement link = doc.createElement('a');
    // link.href = linkToShare;
    // link.click();
  }
}
