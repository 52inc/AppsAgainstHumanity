import 'package:appsagainsthumanity/ui/game/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:appsagainsthumanity/internal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameStatusTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameViewState>(builder: (context, state) {
      if (state.areWeJudge) {
        return _buildText(
          context,
          !state.allResponsesSubmitted ? "Waiting for responses" : "Judge them! You are the Law!",
        );
      } else {
          if (state.allResponsesSubmitted) {
              return _buildText(context, "Judgement day is upon you!");
          } else if (state.haveWeSubmittedResponse) {
              return _buildText(context, "Waiting on other players");
          } else {
              return Container();
          }
      }
    });
  }

  Widget _buildText(BuildContext context, String title) {
    return Text(
      title,
      style: context.theme.textTheme.headline6.copyWith(color: Colors.white),
    );
  }
}
