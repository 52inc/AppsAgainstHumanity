import 'package:appsagainsthumanity/data/features/cards/model/prompt_card.dart';
import 'package:appsagainsthumanity/ui/game/bloc/bloc.dart';
import 'package:appsagainsthumanity/internal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PromptContainer extends StatelessWidget {
  final Widget child;

  static const textPadding = 20.0;

  PromptContainer({this.child});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameViewState>(
      builder: (context, state) {
        var prompt = state.game.turn?.promptCard;
        return Container(
          margin: const EdgeInsets.only(left: 16, right: 16, top: 8),
          child: Column(
            children: [
              _buildPromptSpecial(context, prompt),
              Expanded(
                child: _buildPromptBackground(
                  context: context,
                  card: prompt,
                  child: child,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPromptSpecial(BuildContext context, PromptCard promptCard) {
    if (promptCard != null && promptCard.special != null && promptCard.special.isNotEmpty) {
      return Container(
        height: 36,
        alignment: Alignment.centerRight,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          promptCard.special.toUpperCase(),
          style: context.theme.textTheme.caption.copyWith(
            color: Colors.white,
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _buildPromptBackground({
    @required BuildContext context,
    @required PromptCard card,
    @required Widget child,
  }) {
    return Container(
      child: Material(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        elevation: 4,
        child: Column(
          children: [
            _buildPromptText(context, card),
            Expanded(
              child: child,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPromptText(BuildContext context, PromptCard card) {
    return Container(
      margin: const EdgeInsets.all(textPadding),
      child: Text(
        card.text,
        style: context.theme.textTheme.headline5.copyWith(
          color: Colors.white,
        ),
      ),
    );
  }
}
