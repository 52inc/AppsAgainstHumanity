import 'dart:math';

import 'package:appsagainsthumanity/data/features/cards/model/response_card.dart';
import 'package:appsagainsthumanity/ui/game/screens/gameplay/widget/judge/player_response.dart';
import 'package:flutter/material.dart';

import '../response_card_view.dart';

class OtherResponsesPager extends StatefulWidget {
  final int gameRound;
  final String winningPlayerId;
  final Map<String, List<ResponseCard>> responses;

  OtherResponsesPager(
    this.winningPlayerId,
    this.gameRound,
    this.responses,
  );

  @override
  _OtherResponsesPagerState createState() => _OtherResponsesPagerState();
}

class _OtherResponsesPagerState extends State<OtherResponsesPager> {
  static const double VIEWPORT_FRACTION = 0.93;

  final PageController pageController =
      PageController(viewportFraction: VIEWPORT_FRACTION);

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _responses =
        widget.responses != {} ? Map<String, List<ResponseCard>>() : {};
    var playerResponses = _responses.entries
        .map((e) => PlayerResponse(e.key, e.value.toList()))
        .where((element) => element.playerId != widget.winningPlayerId)
        .toList();
    playerResponses.shuffle(Random(
        widget.gameRound >= 0 ? DateTime.now().millisecondsSinceEpoch : 0));
    return PageView.builder(
      controller: pageController,
      itemCount: playerResponses.length,
      itemBuilder: (context, index) {
        var response = playerResponses[index];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          child: buildResponseCardStack(response.responses),
        );
      },
    );
  }
}
