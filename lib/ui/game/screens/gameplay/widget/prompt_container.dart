import 'package:appsagainsthumanity/data/features/cards/model/prompt_card.dart';
import 'package:appsagainsthumanity/ui/game/bloc/bloc.dart';
import 'package:appsagainsthumanity/internal.dart';
import 'package:appsagainsthumanity/ui/game/screens/gameplay/widget/judge/judge_dredd.dart';
import 'package:appsagainsthumanity/ui/game/screens/gameplay/widget/response_card_view.dart';
import 'package:appsagainsthumanity/ui/game/screens/gameplay/widget/waiting_player_responses.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PromptContainer extends StatelessWidget {
  static const textPadding = 20.0;

  @override
  Widget build(BuildContext context) {
    // We only want this block builder to update when the prompt changes
    return BlocBuilder<GameBloc, GameViewState>(
      condition: (previous, current) {
        return previous.game.turn?.promptCard != current.game.turn?.promptCard;
      },
      builder: (context, state) {
        var prompt = state.game.turn?.promptCard;
        return Container(
          margin: const EdgeInsets.only(top: 8),
          child: Column(
            children: [
              _buildPromptSpecial(context, prompt),
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
                          child: _buildPromptChild(context, state),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Here we will build
  Widget _buildPromptChild(BuildContext context, GameViewState state) {
    // If Not Judge
    // If winner is null && not submitted response => Show selected cards
    // If winner is null && has submitted response => Show waiting on players tile
    // If winner is not null => Show Winning response cards

    // If Judge
    // If not all responses are submitted => Show waiting on players tile
    // If all responses are submitted => Show Pager of all submissions for the judge to swipe between & Show 'pick winner' button

    return BlocBuilder<GameBloc, GameViewState>(builder: (context, state) {
      // Determine if you are judge
      if (state.areWeJudge) {
        if (state.allResponsesSubmitted) {
          return JudgeDredd(state);
        } else {
          return WaitingPlayerResponses(state);
        }
      } else {
        if (state.haveWeSubmittedResponse) {
          return WaitingPlayerResponses(state);
        } else {
          var responseCardStack = buildResponseCardStack(state.selectedCards);
          if (responseCardStack != null) {
            return Dismissible(
              key: Key("responses"),
              direction: DismissDirection.down,
              movementDuration: Duration(milliseconds: 0),
              background: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 24),
                    alignment: Alignment.topCenter,
                    child: Text(
                      "Clear Responses".toUpperCase(),
                      style: context.theme.textTheme.subtitle1
                          .copyWith(color: context.primaryColor, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    child: Icon(
                      MdiIcons.chevronTripleDown,
                      color: context.primaryColor,
                    ),
                  ),
                ],
              ),
              onDismissed: (direction) {
                context.bloc<GameBloc>().add(ClearPickedResponseCards());
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: responseCardStack,
              ),
            );
          } else {
            return Container();
          }
        }
      }
    });
  }

  Widget _buildPromptSpecial(BuildContext context, PromptCard promptCard) {
    if (promptCard != null && promptCard.special != null && promptCard.special.isNotEmpty) {
      return Container(
        height: 36,
        alignment: Alignment.centerRight,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          promptCard.special.toUpperCase(),
          style: context.theme.textTheme.subtitle2.copyWith(
            color: Colors.white,
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _buildPromptBackground({@required BuildContext context, @required PromptCard card}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(state.game?.turn?.promptCard?.source ?? ""),
          behavior: SnackBarBehavior.floating,
        ));
      },
      child: Container(
        width: double.maxFinite,
        margin: const EdgeInsets.symmetric(vertical: textPadding, horizontal: textPadding + 16),
        child: BlocBuilder<GameBloc, GameViewState>(
          builder: (context, state) {
            return Text(
              state.currentPromptText,
              style: context.theme.textTheme.headline5.copyWith(
                color: Colors.white,
              ),
            );
          },
        ),
      ),
    );
  }
}
