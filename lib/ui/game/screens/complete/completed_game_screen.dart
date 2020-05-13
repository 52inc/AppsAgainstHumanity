import 'package:appsagainsthumanity/data/features/game/model/player.dart';
import 'package:appsagainsthumanity/internal.dart';
import 'package:appsagainsthumanity/ui/creategame/create_game_screen.dart';
import 'package:appsagainsthumanity/ui/game/bloc/bloc.dart';
import 'package:appsagainsthumanity/ui/widgets/player_circle_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CompletedGameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<GameBloc, GameViewState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 88),
              child: Text(
                "Winner",
                style: context.theme.textTheme.headline2.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
            _buildAvatar(context, state),
            Container(
              margin: const EdgeInsets.only(top: 24),
              child: Text(
                state.winner?.name ?? Player.DEFAULT_NAME,
                style: context.theme.textTheme.headline4.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(child: Container()),
            if (state.isOurGame)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                width: double.maxFinite,
                child: RaisedButton(
                  child: Text("NEW GAME"),
                  color: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)
                  ),
                  onPressed: () {
                    Analytics().logSelectContent(contentType: 'game', itemId: 'create_new_game');
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => CreateGameScreen()
                    ));
                  },
                ),
              ),
            Container(
              margin: const EdgeInsets.only(top: 8, left: 24, right: 24, bottom: 48),
              width: double.maxFinite,
              child: OutlineButton(
                child: Text("QUIT"),
                textColor: Colors.white,
                borderSide: BorderSide(color: Colors.white),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                highlightedBorderColor: AppColors.primary,
                splashColor: AppColors.primary,
                onPressed: () {
                  Analytics().logSelectContent(contentType: 'game', itemId: 'quit');
                  Navigator.of(context).pop();
                },
              ),
            )
          ],
        );
      },
    );
  }

  Widget _buildAvatar(BuildContext context, GameViewState state) {
    Player winner = state.winner;
    return Container(
      width: 156,
      margin: const EdgeInsets.only(top: 48),
      child: Stack(
        children: [
          Container(
            child: PlayerCircleAvatar(
              radius: 78,
              player: winner,
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondary,
              ),
              child: Icon(
                MdiIcons.crown,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
