import 'dart:convert';

import 'package:appsagainsthumanity/data/app_preferences.dart';
import 'package:appsagainsthumanity/data/features/devices/device_repository.dart';
import 'package:appsagainsthumanity/data/features/game/game_repository.dart';
import 'package:appsagainsthumanity/data/features/game/model/turn.dart';
import 'package:appsagainsthumanity/internal/dynamic_links.dart';
import 'package:appsagainsthumanity/ui/routes.dart';
// import 'package:appsagainsthumanity/internal.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

class PushNotifications {
  PushNotifications._();

  static PushNotifications _instance = PushNotifications._();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  factory PushNotifications() {
    return _instance;
  }

  void checkPermissions() {
    _firebaseMessaging.requestPermission(
      alert: true,
      sound: true,
      badge: true,
      announcement: true,
    );
  }

  void setup() {
    // Setup firebase messaging
    _firebaseMessaging.onTokenRefresh.listen((token) {
      DeviceRepository().updatePushToken(token);
    });

    checkAndUpdateToken();
  }

  Future<void> checkAndUpdateToken({bool force = false}) async {
    String token = await _firebaseMessaging.getToken();
    if (token != AppPreferences().pushToken || force) {
      Logger.root.fine(
          "FCM Token is different from what is stored in preferences, updating device...");
      DeviceRepository().updatePushToken(token);
    }
  }
}

class PushNavigator extends StatefulWidget {
  final Widget child;

  PushNavigator({@required this.child});

  @override
  _PushNavigatorState createState() => _PushNavigatorState();
}

class _PushNavigatorState extends State<PushNavigator> {
  GameRepository _gameRepository;

  @override
  void initState() {
    super.initState();
    _gameRepository = context.repository<GameRepository>();
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("onLaunch()");
      print(JsonEncoder().convert(message));
      handleNotificationClick(message.data);
    });

    /// let's go ahead and sign up here to handle dynamic links
    DynamicLinks.initDynamicLinks(
        context, (gameId) => navigateToGame(gameId, andJoin: true));
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void handleNotificationClick(Map<String, dynamic> message) async {
    var gameId = message['gameId'] ?? message['data']['gameId'];
    if (gameId != null && gameId is String && gameId.isNotEmpty) {
      navigateToGame(gameId);
    }
  }

  void navigateToGame(String gameId, {bool andJoin = false}) async {
    if (gameId != null && gameId.isNotEmpty) {
      var currentRoute = Routes.routeTracer.currentRoute;
      print(currentRoute);
      if (currentRoute.settings.arguments == gameId) {
        // It looks like the current game is up fromt
        print("Game is already in the foreground");
        return;
      }
      try {
        var game = await _gameRepository.getGame(gameId, andJoin: andJoin);
        if (game != null) {
          /*
           * Neuter the turn winner out of the otherwise the winner bottom sheet will never show
           */
          if (game.turn != null) {
            game = game.copyWith(
                turn: Turn(
                    judgeId: game.turn.judgeId,
                    responses: game.turn.responses,
                    promptCard: game.turn.promptCard,
                    winner: null));
          }

          if (currentRoute.settings.name == Routes.game) {
            print("Replacing current shown game");
            currentRoute.navigator.pushReplacement(GamePageRoute(game));
          } else if (currentRoute.settings.name == "/") {
            print("User should be in the homescreen, push game");
            currentRoute.navigator.push(GamePageRoute(game));
          } else if (currentRoute is MaterialPageRoute) {
            print("User is not in a game or homescreen");
            currentRoute.navigator
              ..popUntil((route) => route.settings.name == "/")
              ..push(GamePageRoute(game));
          }
        } else {
          print("Unable to join the Game($gameId)");
        }
      } catch (e) {
        print(e);
      }
    }
  }
}
