import 'dart:io';

import 'package:appsagainsthumanity/internal/push.dart';
import 'package:appsagainsthumanity/ui/creategame/create_game_screen.dart';
import 'package:appsagainsthumanity/ui/home/bloc/bloc.dart';
import 'package:appsagainsthumanity/ui/home/widgets/home_outline_button.dart';
import 'package:appsagainsthumanity/ui/home/widgets/join_game_widget.dart';
import 'package:appsagainsthumanity/ui/home/widgets/past_game.dart';
import 'package:appsagainsthumanity/ui/home/widgets/settings_widget.dart';
import 'package:appsagainsthumanity/ui/home/widgets/user_widget.dart';
import 'package:appsagainsthumanity/ui/profile/profile_screen.dart';
import 'package:appsagainsthumanity/ui/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appsagainsthumanity/internal.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomeScreenV2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenV2State();
}

class _HomeScreenV2State extends State<HomeScreenV2> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(context.repository(), context.repository())..add(HomeStarted()),
      child: MultiBlocListener(
        listeners: [
          // Error Listener
          BlocListener<HomeBloc, HomeState>(
            condition: (previous, current) => previous.error != current.error && current.error != null,
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

          // Joined Game listener that opens a 'joined' game
          BlocListener<HomeBloc, HomeState>(
            condition: (previous, current) => previous.joinedGame?.id != current.joinedGame?.id,
            listener: (context, state) {
              if (state.joinedGame != null) {
                Navigator.of(context).push(GamePageRoute(state.joinedGame));
              }
            },
          )
        ],
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        var topMargin = MediaQuery.of(context).padding.top; //FIXME:+ (Platform.isAndroid ? 24 : 8);
        return Scaffold(
          body: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom,
              top: topMargin,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // Title
                Container(
                  margin: const EdgeInsets.only(left: 24, right: 24),
                  child: Text(
                    context.strings.appNameDisplay,
                    style: GoogleFonts.raleway(
                        textStyle: context.theme.textTheme.headline3.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 48,
                    )),
                  ),
                ),

                Container(
                  margin: const EdgeInsets.only(left: 24, right: 24, top: 32),
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    direction: Axis.horizontal,
                    spacing: 12,
                    runSpacing: 16,
                    children: [
                      SettingsWidget(),
                      UserWidget(
                        state: state,
                        onTap: () {
                          Analytics().logSelectContent(contentType: 'action', itemId: 'profile');
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => ProfileScreen()));
                        },
                      ),
                      HomeOutlineButton(
                        icon: Icon(
                          MdiIcons.gamepad,
                          color: AppColors.primaryVariant,
                        ),
                        text: "New Game",
                        onTap: state.joiningGame == null ? () {
                          Analytics().logSelectContent(contentType: 'action', itemId: 'start_game');
                          PushNotifications().checkPermissions();
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateGameScreen()));
                        } : null,
                      ),
                      JoinGameWidget(state),
                    ],
                  ),
                ),

                if (state.games.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(left: 24, top: 24, right: 24),
                    child: Text(
                      "Past Games",
                      style: context.theme.textTheme.headline4.copyWith(
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                        fontSize: 24,
                      ),
                    ),
                  ),

                if (state.games.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    child: Divider(
                      height: 1,
                      color: Colors.white12,
                    ),
                  ),

                if (state.games.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: state.games.length,
                        itemBuilder: (context, index) {
                          var game = state.games[index];
                          var isLeavingGame = game.id == state.leavingGame?.id;
                          return PastGame(game, isLeavingGame);
                        }),
                  )
              ],
            ),
          ),
        );
      },
    );
  }
}
