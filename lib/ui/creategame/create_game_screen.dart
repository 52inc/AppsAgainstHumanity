import 'package:appsagainsthumanity/ui/creategame/bloc/bloc.dart';
import 'package:appsagainsthumanity/internal.dart';
import 'package:appsagainsthumanity/ui/creategame/widgets/card_set_list.dart';
import 'package:appsagainsthumanity/ui/creategame/widgets/game_options.dart';
import 'package:appsagainsthumanity/ui/routes.dart';
import 'package:appsagainsthumanity/ui/widgets/reponsive_widget_mediator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kt_dart/kt.dart';

import 'layouts/mobile_layout.dart';
import 'layouts/tablet_layout.dart';

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
            // Error Listener
            BlocListener<CreateGameBloc, CreateGameState>(
              condition: (previous, current) => current.error != previous.error,
              listener: (context, state) {
                if (state.error != null) {
                  context.scaffold
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                        SnackBar(
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [Text(state.error), Icon(Icons.error)],
                          ),
                          backgroundColor: Colors.redAccent,
                        )
                    );
                }
              },
            ),

            // New Game Listener
            BlocListener<CreateGameBloc, CreateGameState>(
              condition: (previous, current) => current.createdGame?.id != previous.createdGame?.id,
              listener: (context, state) {
                if (state.createdGame != null) {
                  Navigator.of(context).pushReplacement(GamePageRoute(state.createdGame));
                }
              },
            ),
          ],
          child: ResponsiveWidgetMediator(
            mobile: (_) => MobileLayout(),
            tablet: (_) => TabletLayout(),
          ),
        ),
      ),
    );
  }
}
