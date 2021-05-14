import 'package:appsagainsthumanity/ui/creategame/bloc/bloc.dart';
import 'package:appsagainsthumanity/internal.dart';
import 'package:appsagainsthumanity/ui/creategame/widgets/card_set_list.dart';
import 'package:appsagainsthumanity/ui/creategame/widgets/game_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kt_dart/kt.dart';

class TabletLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateGameBloc, CreateGameState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            brightness: Brightness.dark,
            title: Text(
              context.strings.titleNewGame,
              style: context.theme.textTheme.headline6.copyWith(color: Colors.white),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            notchMargin: 8,
            shape: CircularNotchedRectangle(),
            child: Container(
              height: 56,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        state.isLoading
                            ? "Loading..."
                            : "${state.totalPrompts} Prompts ${state.totalResponses} Responses",
                        style: context.theme.textTheme.headline6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          floatingActionButton: state.selectedSets.isNotEmpty() && !state.isLoading
              ? FloatingActionButton(
                  child: Icon(Icons.check),
                  onPressed: () async {
                    // Start game?
                    Analytics().logSelectContent(contentType: 'action', itemId: 'create_game');
                    context.bloc<CreateGameBloc>().add(CreateGame());
                  },
                )
              : null,
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CardSetList(state),
              ),
              ConstrainedBox(
                constraints: BoxConstraints.tightFor(width: 400),
                child: IntrinsicHeight(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    alignment: Alignment.topCenter,
                    child: Material(
                      borderRadius: BorderRadius.circular(16),
                      elevation: 2,
                      color: context.responseCardColor,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: GameOptions(state),
                      )
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
