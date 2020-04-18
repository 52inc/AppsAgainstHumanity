import 'package:appsagainsthumanity/data/features/cards/model/response_card.dart';
import 'package:appsagainsthumanity/internal.dart';
import 'package:appsagainsthumanity/ui/game/bloc/bloc.dart';
import 'package:appsagainsthumanity/ui/game/screens/gameplay/widget/game_bottom_sheet.dart';
import 'package:appsagainsthumanity/ui/game/screens/gameplay/widget/judge/judge_bar.dart';
import 'package:appsagainsthumanity/ui/game/screens/gameplay/widget/player_list.dart';
import 'package:appsagainsthumanity/ui/game/screens/gameplay/widget/player_response_picker.dart';
import 'package:appsagainsthumanity/ui/game/screens/gameplay/widget/prompt_container.dart';
import 'package:appsagainsthumanity/ui/game/screens/gameplay/widget/response_card_view.dart';
import 'package:flutter/material.dart';
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
                child: Text(
                  "Waiting for responses",
                  style: context.theme.textTheme.headline6.copyWith(
                    color: Colors.black87
                  ),
                ),
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
                                  child: PlayerList(widget.state.game)
                                );
                              }
                          );
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
      body: Container(
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
      ),
    );
  }
}
