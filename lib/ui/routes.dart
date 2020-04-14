import 'package:flutter/material.dart';

class Routes {
    Routes._();

    static const String signIn = "/sign_in";
    static const String home = "/home";

    static RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
}
