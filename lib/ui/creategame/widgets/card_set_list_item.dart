import 'package:appsagainsthumanity/ui/creategame/bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appsagainsthumanity/data/features/cards/model/card_set.dart';
import 'package:appsagainsthumanity/internal.dart';
import 'package:appsagainsthumanity/util/cah_scrubber.dart';
import 'package:flutter/material.dart';

class CardSetListItem extends StatelessWidget {
  final CardSet cardSet;
  final bool isSelected;

  CardSetListItem(this.cardSet, this.isSelected);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(CahScrubber.scrub(cardSet.name!)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 6),
      leading: Checkbox(
        value: isSelected,
        activeColor: AppColors.primary,
        onChanged: (value) {
          Analytics()
              .logSelectContent(contentType: 'card_set', itemId: cardSet.name);
          context.read<CreateGameBloc>().add(CardSetSelected(cardSet));
        },
      ),
      onTap: () {
        Analytics()
            .logSelectContent(contentType: 'card_set', itemId: cardSet.name);
        context.read<CreateGameBloc>().add(CardSetSelected(cardSet));
      },
    );
  }
}
