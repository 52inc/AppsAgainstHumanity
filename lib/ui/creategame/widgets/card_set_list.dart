import 'package:appsagainsthumanity/data/features/cards/model/card_set.dart';
import 'package:appsagainsthumanity/ui/creategame/bloc/bloc.dart';
import 'package:appsagainsthumanity/ui/creategame/widgets/card_set_list_item.dart';
import 'package:appsagainsthumanity/ui/creategame/widgets/header_item.dart';
import 'package:flutter/material.dart';
import 'package:kt_dart/kt.dart';

class CardSetList extends StatelessWidget {
  final CreateGameState state;

  CardSetList(this.state);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: state.isLoading
              ? _buildLoading()
              : _buildList(state.cardSets, state.selectedSets),
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
