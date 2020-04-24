import 'package:appsagainsthumanity/data/features/game/model/game.dart';
import 'package:appsagainsthumanity/ui/game/bloc/bloc.dart';
import 'package:appsagainsthumanity/ui/game/screens/gameplay/widget/player_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayerList extends StatelessWidget {
  final Game initialGame;
  final ScrollController scrollController;

  PlayerList(this.initialGame, this.scrollController);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GameBloc(null, context.repository())..add(Subscribe(initialGame.id)),
      child: BlocBuilder<GameBloc, GameViewState>(
        builder: (context, state) {
          var players = (state.players ?? []).where((element) => element.isInactive != true).toList();
          return ListView.builder(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: players.length,
            itemBuilder: (context, index) {
              var player = players[index];
              var isJudge = player.id == state.game.turn?.judgeId;
              var hasDownvoted = state.downvotes?.contains(player.id) ?? false;
              return PlayerItem(
                player,
                isJudge: isJudge,
                hasDownvoted: hasDownvoted,
              );
            },
          );
        },
      ),
    );
  }
}
