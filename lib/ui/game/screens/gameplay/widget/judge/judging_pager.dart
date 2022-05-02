import 'dart:math';

import 'package:appsagainsthumanity/data/features/cards/model/response_card.dart';
import 'package:appsagainsthumanity/internal.dart';
import 'package:appsagainsthumanity/ui/game/bloc/bloc.dart';
import 'package:appsagainsthumanity/ui/game/screens/gameplay/widget/judge/judge_dredd.dart';
import 'package:appsagainsthumanity/ui/game/screens/gameplay/widget/judge/player_response.dart';
import 'package:appsagainsthumanity/ui/game/screens/gameplay/widget/response_card_view.dart';
import 'package:flutter/material.dart';

class JudgingPager extends StatelessWidget {
  final GameViewState state;
  final JudgementController controller;

  JudgingPager({
    required this.state,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    var responses =
        state.game?.turn?.responses ?? Map<String, List<ResponseCard>>();
    var playerResponses = responses.entries
        .map((e) => PlayerResponse(e.key, e.value.toList()))
        .toList();
    playerResponses.shuffle(
        Random(state.game?.round ?? DateTime.now().millisecondsSinceEpoch));
    controller.setCurrentResponse(
        playerResponses[0], 0, playerResponses.length);
    return PageView.builder(
      controller: controller.pageController,
      itemCount: playerResponses.length,
      itemBuilder: (context, index) {
        var response = playerResponses[index];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          child: buildResponseCardStack(response.responses),
        );
      },
      onPageChanged: (index) {
        Analytics().logSelectContent(
            contentType: 'judge', itemId: 'response_change_$index');
        var playerResponse = playerResponses[index];
        controller.setCurrentResponse(
            playerResponse, index, playerResponses.length);
      },
    );
  }
}
