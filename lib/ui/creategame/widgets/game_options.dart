import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appsagainsthumanity/internal.dart';
import 'package:appsagainsthumanity/ui/creategame/bloc/bloc.dart';
import 'package:appsagainsthumanity/ui/creategame/widgets/count_preference.dart';
import 'package:flutter/material.dart';

class GameOptions extends StatelessWidget {
  final CreateGameState state;

  GameOptions(this.state);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CountPreference(
          state.prizesToWin,
          title: "Prizes to win",
          subtitle: "Choose the number of prize cards it would take to win",
          min: 1,
          max: 15,
          onValueChanged: (value) {
            Analytics().logSelectContent(contentType: 'game_option', itemId: 'prizes_to_win');
            context.bloc<CreateGameBloc>().add(ChangePrizesToWin(value));
          },
        ),
        CountPreference(
          state.playerLimit,
          title: "Max # of players",
          subtitle: "Pick the number of players allowed to join your game",
          min: 5,
          max: 30,
          onValueChanged: (value) {
            Analytics().logSelectContent(contentType: 'game_option', itemId: 'player_limit');
            context.bloc<CreateGameBloc>().add(ChangePlayerLimit(value));
          },
        ),
        SwitchListTile(
          title: Text("Enable \"PICK 2\""),
          subtitle: Text("Allow \"PICK 2\" prompt cards"),
          activeColor: AppColors.primary,
          value: state.pick2Enabled,
          onChanged: (value) {
            Analytics().logSelectContent(contentType: 'game_option', itemId: 'pick2');
            context.bloc<CreateGameBloc>().add(ChangePick2Enabled(value));
          },
        ),
        SwitchListTile(
          title: Text("Enable \"DRAW 2, PICK 3\""),
          subtitle: Text("Allow \"DRAW 2, PICK 3\" prompt cards"),
          activeColor: AppColors.primary,
          value: state.draw2pick3Enabled,
          onChanged: (value) {
            Analytics().logSelectContent(contentType: 'game_option', itemId: 'draw2_pick3');
            context.bloc<CreateGameBloc>().add(ChangeDraw2Pick3Enabled(value));
          },
        ),
      ],
    );
  }
}
