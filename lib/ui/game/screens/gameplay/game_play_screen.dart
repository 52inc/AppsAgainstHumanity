import 'package:appsagainsthumanity/data/features/cards/model/response_card.dart';
import 'package:appsagainsthumanity/internal.dart';
import 'package:appsagainsthumanity/ui/game/bloc/bloc.dart';
import 'package:appsagainsthumanity/ui/game/screens/gameplay/widget/game_bottom_sheet.dart';
import 'package:appsagainsthumanity/ui/game/screens/gameplay/widget/game_status_title.dart';
import 'package:appsagainsthumanity/ui/game/screens/gameplay/widget/judge/judge_bar.dart';
import 'package:appsagainsthumanity/ui/game/screens/gameplay/widget/player_list.dart';
import 'package:appsagainsthumanity/ui/game/screens/gameplay/widget/player_response_picker.dart';
import 'package:appsagainsthumanity/ui/game/screens/gameplay/widget/prompt_container.dart';
import 'package:appsagainsthumanity/ui/game/screens/gameplay/widget/response_card_view.dart';
import 'package:appsagainsthumanity/ui/game/screens/gameplay/widget/turn_winner_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class GamePlayScreen extends StatefulWidget {
  final GameViewState state;

  GamePlayScreen(this.state);

  @override
  State<StatefulWidget> createState() => _GamePlayScreenState();
}

class _GamePlayScreenState extends State<GamePlayScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        notchMargin: 8,
        shape: CircularNotchedRectangle(),
        color: AppColors.primary,
        child: Container(
          height: 56,
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 8),
                child: IconButton(
                  icon: Icon(Icons.close),
                  color: Colors.black87,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),

              // TODO: Abstract into it's own widget so that it can implement it's
              // TODO: own conditional BlocBuilder
              Container(
                margin: const EdgeInsets.only(left: 16),
                child: GameStatusTitle(),
              ),

              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 16, right: 16),
                  alignment: Alignment.centerRight,
                  child: Builder(
                    builder: (context) {
                      return IconButton(
                        icon: Icon(MdiIcons.accountGroup),
                        color: Colors.black87,
                        onPressed: () {
                          /*
                           * This is kind of hacky since we have to add a new GameBloc provider since the modal
                           * is a different view tree
                           */
                          showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              builder: (context) {
                                return GameBottomSheet(
                                  title: "Players",
                                  actions: [
                                    Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 24),
                                      height: 56,
                                      alignment: Alignment.center,
                                      child: Text(
                                        widget.state.game.gid,
                                        style: context.theme.textTheme.headline6.copyWith(
                                          color: AppColors.secondary,
                                        ),
                                      ),
                                    )
                                  ],
                                  child: PlayerList(widget.state.game),
                                );
                              });
                        },
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: BlocListener<GameBloc, GameViewState>(
        condition: (previous, current) {
          return current.game.turn?.winner != previous.game.turn?.winner;
        },
        listener: (context, state) {
          // Show bottom sheet modal for the winner
          var turnWinner = state.game.turn?.winner;
          if (turnWinner != null) {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (context) {
                return GameBottomSheet(
                  title: "Round ${state.game.round}",
                  child: TurnWinnerSheet(turnWinner),
                );
              },
            );
          }
        },
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).systemGestureInsets.top),
      child: Column(
        children: [
          JudgeBar(),
          Expanded(
            child: Stack(
              children: <Widget>[
                PromptContainer(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 256,
                    child: PlayerResponsePicker(),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
