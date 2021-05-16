import 'package:appsagainsthumanity/data/features/cards/model/prompt_card.dart';
import 'package:appsagainsthumanity/ui/game/bloc/bloc.dart';
import 'package:appsagainsthumanity/internal.dart';
// import 'package:appsagainsthumanity/ui/game/screens/gameplay/widget/judge/judge_dredd.dart';
// import 'package:appsagainsthumanity/ui/game/screens/gameplay/widget/response_card_view.dart';
// import 'package:appsagainsthumanity/ui/game/screens/gameplay/widget/waiting_player_responses.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PromptCardView extends StatelessWidget {
  static const textPadding = 20.0;

  final GameViewState state;
  final Widget child;
  final EdgeInsets margin;

  PromptCardView(
      {@required this.state, @required this.child, EdgeInsets margin})
      : margin = margin ?? const EdgeInsets.symmetric(horizontal: 16);

  @override
  Widget build(BuildContext context) {
    // We only want this block builder to update when the prompt changes
    var prompt = state.game.turn?.winner?.promptCard;
    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                _buildPromptBackground(
                  context: context,
                  card: prompt,
                ),
                Column(
                  children: [
                    _buildPromptText(context, state),
                    Expanded(
                      child: child,
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromptBackground(
      {@required BuildContext context, @required PromptCard card}) {
    return Container(
      margin: margin,
      child: Material(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        elevation: 4,
        child: Container(
          height: double.maxFinite,
        ),
      ),
    );
  }

  Widget _buildPromptText(BuildContext context, GameViewState state) {
    return GestureDetector(
      onLongPress: () {
        Analytics().logSelectContent(
            contentType: 'action', itemId: 'view_prompt_source');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(state.game?.turn?.winner?.promptCard?.set ?? ""),
          behavior: SnackBarBehavior.floating,
        ));
      },
      child: Container(
        width: double.maxFinite,
        margin: const EdgeInsets.symmetric(
                vertical: textPadding, horizontal: textPadding)
            .add(margin),
        child: Text(
          state.lastPromptText,
          style: context.cardTextStyle(Colors.white),
        ),
      ),
    );
  }
}
