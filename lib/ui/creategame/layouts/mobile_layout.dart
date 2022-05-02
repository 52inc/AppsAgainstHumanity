import 'package:appsagainsthumanity/ui/creategame/bloc/bloc.dart';
import 'package:appsagainsthumanity/internal.dart';
import 'package:appsagainsthumanity/ui/creategame/widgets/card_set_list.dart';
import 'package:appsagainsthumanity/ui/creategame/widgets/game_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kt_dart/kt.dart';

class MobileLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateGameBloc, CreateGameState>(
      builder: (context, state) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarBrightness: Brightness.dark,
              ),
              // brightness: Brightness.dark,
              title: Text(
                context.strings.titleNewGame,
                style: context.theme.textTheme.headline6!
                    .copyWith(color: Colors.white),
              ),
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              bottom: TabBar(
                labelColor: Colors.white,
                tabs: [
                  Tab(text: "CARDS"),
                  Tab(text: "OPTIONS"),
                ],
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
            floatingActionButtonLocation:
                FloatingActionButtonLocation.endDocked,
            floatingActionButton:
                state.selectedSets.isNotEmpty() && !state.isLoading
                    ? FloatingActionButton(
                        child: Icon(Icons.check),
                        onPressed: () async {
                          // Start game?
                          Analytics().logSelectContent(
                              contentType: 'action', itemId: 'create_game');
                          context.read<CreateGameBloc>().add(CreateGame());
                        },
                      )
                    : null,
            body: TabBarView(
              children: [
                CardSetList(state),
                GameOptions(state),
              ],
            ),
          ),
        );
      },
    );
  }
}
