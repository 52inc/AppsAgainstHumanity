import 'package:appsagainsthumanity/data/features/game/game_repository.dart';
import 'package:appsagainsthumanity/internal.dart';
import 'package:appsagainsthumanity/ui/game/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ReDealButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameViewState>(
      builder: (context, state) {
        if (!state.areWeJudge && !state.haveWeSubmittedResponse && (state.currentPlayer?.prizes?.length ?? 0) > 0) {
          return IconButton(
            icon: Icon(MdiIcons.cardsVariant),
            tooltip: "Re-deal your hand",
            color: Colors.white,
            onPressed: () async {
              var result = await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Deal new hand?'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      content: RichText(
                        text: TextSpan(text: 'Spend ', children: [
                          TextSpan(
                              text: '1 of ${state.currentPlayer.prizes.length} prize cards',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: ' to deal you a new hand?')
                        ]),
                      ),
                      actions: [
                        FlatButton(
                          child: Text('CANCEL'),
                          textColor: AppColors.secondary,
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                        ),
                        FlatButton(
                          child: Text('DEAL'),
                          textColor: AppColors.secondary,
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                        ),
                      ],
                    );
                  });
              if (result ?? false) {
                await context.repository<GameRepository>().reDealHand(state.game.id);
              }
            },
          );
        } else {
          return Container();
        }
      },
    );
  }
}
