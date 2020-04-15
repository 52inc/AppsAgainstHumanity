import 'package:appsagainsthumanity/data/features/game/model/player.dart';
import 'package:appsagainsthumanity/internal.dart';
import 'package:appsagainsthumanity/ui/game/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class WaitingRoomScreen extends StatelessWidget {
  final GameViewState gameState;

  WaitingRoomScreen({@required this.gameState});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomAppBar(
        color: AppColors.primary,
        shape: CircularNotchedRectangle(),
        notchMargin: 8,
        child: Container(
          height: 56,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                onPressed: () {
                  // Exit waiting room back to homescreen
                  Navigator.of(context).pop();
                },
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  gameState.game.gid,
                  style: context.theme.textTheme.headline6.copyWith(color: Colors.white),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 92),
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: Icon(MdiIcons.accountMultiplePlus),
                    onPressed: () {},
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: gameState.isOurGame
          ? FloatingActionButton(
              child: Icon(MdiIcons.play),
              onPressed: () {
                // TODO: Start the game, if enough players exist
              },
            )
          : null,
      body: Column(
        children: [
          Material(
            elevation: 2,
            child: Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).systemGestureInsets.top),
              height: 56,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      gameState.game.gid,
                      textAlign: TextAlign.start,
                      style: context.theme.textTheme.headline6.copyWith(color: AppColors.secondary),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "Waiting for players",
                      textAlign: TextAlign.center,
                      style: context.theme.textTheme.headline6,
                    ),
                  ),
                  Container(
                    width: 24,
                    height: 24,
                    margin: const EdgeInsets.only(right: 16, left: 84),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _buildPlayerList(context),
          )
        ],
      ),
    );
  }

  /// Build the player list which is the only component in this particular tree
  /// that needs to update to the change in game state
  Widget _buildPlayerList(BuildContext context) {
    return BlocBuilder<GameBloc, GameViewState>(
      bloc: context.bloc<GameBloc>(),
      builder: (context, state) {
        print("Build Player List: ${state.players}");
        var players = state.players ?? [];
        return ListView.builder(
            itemCount: players.length,
            itemBuilder: (context, index) {
              var player = players[index];
              return _buildPlayerTile(context, player);
            });
      },
    );
  }

  Widget _buildPlayerTile(BuildContext context, Player player) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
      onTap: () {},
      title: Text(
        player.name,
        style: context.theme.textTheme.subtitle1.copyWith(color: Colors.white),
      ),
      leading: CircleAvatar(
        radius: 20,
        backgroundImage: player.avatarUrl != null ? NetworkImage(player.avatarUrl) : null,
        backgroundColor: AppColors.primary,
        child: player.avatarUrl == null ? Text(player.name.split(' ').map((e) => e[0]).join().toUpperCase()) : null,
      ),
    );
  }
}
