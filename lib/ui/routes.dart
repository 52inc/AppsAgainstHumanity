import 'package:appsagainsthumanity/data/features/game/model/game.dart';
import 'package:appsagainsthumanity/ui/game/game_screen.dart';
import 'package:flutter/material.dart';

class Routes {
  Routes._();

  static const String signIn = "/sign_in";
  static const String home = "/home";
  static const String game = "/game";

  static RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
  static RouteTracer routeTracer = RouteTracer();
}

class GamePageRoute<T> extends MaterialPageRoute<T> {
  GamePageRoute(Game game)
      : super(
          settings: RouteSettings(
            name: Routes.game,
            arguments: game.id,
          ),
          builder: (_) => GameScreen(game),
        );
}

class NoAnimationPageRoute<T> extends MaterialPageRoute<T> {
  NoAnimationPageRoute({WidgetBuilder? builder}) : super(builder: builder!);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }
}

class RouteTracer extends NavigatorObserver {
  Route<dynamic>? currentRoute;
  bool logEnabled = false;

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    currentRoute = previousRoute;
    if (logEnabled) print("Route Changed => $currentRoute");
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    currentRoute = newRoute;
    if (logEnabled) print("Route Changed => $currentRoute");
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    currentRoute = previousRoute;
    if (logEnabled) print("Route Changed => $currentRoute");
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    currentRoute = route;
    if (logEnabled) print("Route Changed => $currentRoute");
  }
}
