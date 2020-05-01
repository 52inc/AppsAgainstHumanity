import 'package:appsagainsthumanity/data/features/cards/model/card_set.dart';
import 'package:appsagainsthumanity/data/features/game/game_repository.dart';
import 'package:appsagainsthumanity/ui/creategame/bloc/bloc.dart';
import 'package:appsagainsthumanity/internal.dart';
import 'package:appsagainsthumanity/ui/creategame/widgets/CountPreference.dart';
import 'package:appsagainsthumanity/ui/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kt_dart/kt.dart';

class CreateGameScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CreateGameScreenState();
}

class _CreateGameScreenState extends State<CreateGameScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: BlocProvider(
        create: (context) => CreateGameBloc(
          context.repository(),
          context.repository(),
        )..add(ScreenLoaded()),
        child: MultiBlocListener(
          listeners: [
            BlocListener<CreateGameBloc, CreateGameState>(
              condition: (previous, current) => current.error != previous.error,
              listener: (context, state) {
                if (state.error != null) {
                  Scaffold.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [Text(state.error), Icon(Icons.error)],
                        ),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                }
              },
            ),
            BlocListener<CreateGameBloc, CreateGameState>(
              condition: (previous, current) => current.createdGame?.id != previous.createdGame?.id,
              listener: (context, state) {
                if (state.createdGame != null) {
                  Navigator.of(context).pushReplacement(GamePageRoute(state.createdGame));
                }
              },
            ),
          ],
          child: _buildScaffold(),
        ),
      ),
    );
  }

  Widget _buildScaffold() {
    return BlocBuilder<CreateGameBloc, CreateGameState>(
      builder: (context, state) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
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
                          state.isLoading ? "Loading..." : "${state.selectedSets.size} Selected",
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
                      context.bloc<CreateGameBloc>().add(CreateGame());
                    },
                  )
                : null,
            body: TabBarView(
              children: [
                _buildCardSetLists(state),
                _buildGameOptions(context, state),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCardSetLists(CreateGameState state) {
    return Column(
      children: [
        Expanded(
          child: state.isLoading ? _buildLoading() : _buildList(state.cardSets, state.selectedSets),
        ),
      ],
    );
  }

  Widget _buildGameOptions(BuildContext context, CreateGameState state) {
    return Column(
      children: [
        CountPreference(
          state.prizesToWin,
          title: "Prizes to win",
          subtitle: "Choose the number of prize cards it would take to win",
          min: 1,
          max: 15,
          onValueChanged: (value) {
            context.bloc<CreateGameBloc>().add(ChangePrizesToWin(value));
          },
        ),
        CountPreference(
          state.playerLimit,
          title: "Max # of players",
          subtitle: "Pick the number of players allowed to join your game",
          min: 5,
          max: 30,
          onValueChanged: (value) {
            context.bloc<CreateGameBloc>().add(ChangePlayerLimit(value));
          },
        ),
        SwitchListTile(
          title: Text("Enable \"PICK 2\""),
          subtitle: Text("Allow \"PICK 2\" prompt cards"),
          activeColor: AppColors.primary,
          value: state.pick2Enabled,
          onChanged: (value) {
            context.bloc<CreateGameBloc>().add(ChangePick2Enabled(value));
          },
        ),
        SwitchListTile(
          title: Text("Enable \"DRAW 2, PICK 3\""),
          subtitle: Text("Allow \"DRAW 2, PICK 3\" prompt cards"),
          activeColor: AppColors.primary,
          value: state.draw2pick3Enabled,
          onChanged: (value) {
            context.bloc<CreateGameBloc>().add(ChangeDraw2Pick3Enabled(value));
          },
        ),
      ],
    );
  }

  Widget _buildLoading() {
    return Container(
      height: double.maxFinite,
      alignment: Alignment.center,
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildList(KtList<CardSet> sets, KtSet<CardSet> selected) {
    var groupedSets = sets.groupBy((cs) => cs.source);
    print("Sets: $sets");
    print("Grouped Sets: $groupedSets");
    var widgets = groupedSets.keys.toList().sortedWith((a, b) {
      var aW = keyWeight(a);
      var bW = keyWeight(b);
      if (aW.compareTo(bW) == 0) {
        return a.compareTo(b);
      } else {
        return aW.compareTo(bW);
      }
    }).flatMap((key) {
      var items = groupedSets.get(key).map((cs) => CardSetListItem(cs, selected.contains(cs)));
      var allItemsSelected = items.all((i) => i.isSelected);
      var noItemsSelected = items.none((i) => i.isSelected);
      return mutableListOf<Widget>(
        HeaderItem(key, allItemsSelected ? true : noItemsSelected ? false : null),
      )..addAll(items);
    });

    return ListView.builder(
      itemCount: widgets.size,
      itemBuilder: (context, index) => widgets[index],
    );
  }

  int keyWeight(String key) {
    if (key == "Developer") {
      return 0;
    } else if (key == "CAH Main Deck") {
      return 1;
    } else if (key == "CAH Expansions") {
      return 2;
    } else if (key == "CAH Packs") {
      return 3;
    } else if (key.startsWith('CAH Packs/')) {
      return 4;
    } else {
      return 5;
    }
  }
}

class HeaderItem extends StatelessWidget {
  final String title;
  final bool isChecked;

  HeaderItem(this.title, [this.isChecked]);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.bloc<CreateGameBloc>().add(CardSourceSelected(title, isChecked));
      },
      child: Column(
        children: [
          Divider(
            height: 1,
          ),
          Container(
            height: 48,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Row(
              children: <Widget>[
                Checkbox(
                  value: isChecked,
                  tristate: true,
                  onChanged: (value) {
                    context.bloc<CreateGameBloc>().add(CardSourceSelected(title, value));
                  },
                  activeColor: AppColors.primary,
                  checkColor: Colors.white,
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 16),
                    child: Text(
                      title ?? "_UNKNOWN_",
                      style: context.theme.textTheme.subtitle2.copyWith(
                        color: AppColors.primaryVariant,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CardSetListItem extends StatelessWidget {
  final CardSet cardSet;
  final bool isSelected;

  CardSetListItem(this.cardSet, this.isSelected);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(cardSet.name),
      contentPadding: const EdgeInsets.symmetric(horizontal: 6),
      leading: Checkbox(
        value: isSelected,
        activeColor: AppColors.primary,
        onChanged: (value) {
          context.bloc<CreateGameBloc>().add(CardSetSelected(cardSet));
        },
      ),
      onTap: () {
        context.bloc<CreateGameBloc>().add(CardSetSelected(cardSet));
      },
    );
  }
}
