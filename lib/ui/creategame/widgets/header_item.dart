import 'package:appsagainsthumanity/ui/creategame/bloc/bloc.dart';
import 'package:appsagainsthumanity/util/cah_scrubber.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appsagainsthumanity/internal.dart';
import 'package:flutter/material.dart';

class HeaderItem extends StatelessWidget {
  final String title;
  final bool? isChecked;

  HeaderItem(this.title, [this.isChecked]);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Analytics()
            .logSelectContent(contentType: 'card_set_source', itemId: title);
        context
            .read<CreateGameBloc>()
            .add(CardSourceSelected(title, isChecked!));
      },
      child: Column(
        children: [
          Divider(
            height: 1,
            color: Colors.white12,
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
                    Analytics().logSelectContent(
                        contentType: 'card_set_source', itemId: title);
                    context
                        .read<CreateGameBloc>()
                        .add(CardSourceSelected(title, value!));
                  },
                  activeColor: AppColors.primary,
                  checkColor: Colors.white,
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 16),
                    child: Text(
                      CahScrubber.scrub(title) != "" ? "_UNKNOWN_" : "",
                      style: context.theme.textTheme.subtitle2?.copyWith(
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
