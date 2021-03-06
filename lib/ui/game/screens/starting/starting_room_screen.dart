import 'package:appsagainsthumanity/ui/game/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:appsagainsthumanity/internal.dart';

class StartingRoomScreen extends StatelessWidget {
  final GameViewState state;

  StartingRoomScreen(this.state);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        textTheme: context.theme.textTheme,
        iconTheme: context.theme.iconTheme,
        title: Text("Game is starting..."),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(72),
          child: Container(
            height: 72,
            padding: const EdgeInsets.only(bottom: 8),
            alignment: Alignment.center,
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 72),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Game ID",
                        style: context.theme.textTheme.bodyText1.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                      Text(
                        state.game.gid,
                        style: context.theme.textTheme.headline4.copyWith(
                          color: context.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                child: CircularProgressIndicator(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
