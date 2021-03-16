import 'package:appsagainsthumanity/internal.dart';
import 'package:appsagainsthumanity/internal/push.dart';
import 'package:appsagainsthumanity/ui/home/home_screen_v2.dart';
import 'package:appsagainsthumanity/ui/routes.dart';
import 'package:appsagainsthumanity/ui/signin/sign_in_screen.dart';
import 'package:appsagainsthumanity/ui/terms_screen.dart';
import 'package:flutter/material.dart';

import 'package:firebase_analytics/observer.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'authentication_bloc/authentication_bloc.dart';

class App extends StatelessWidget {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'Apps Against Humanity',
      theme: AppThemes.light,
      darkTheme: AppThemes.dark,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'), // English
      ],
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: Analytics()),
        Routes.routeObserver,
        Routes.routeTracer
      ],
      home: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: PushNavigator(
          child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              if (state is Unauthenticated) {
                return SignInScreen();
              } else if (state is NeedsAgreeToTerms) {
                return TermsOfServiceScreen();
              } else if (state is Authenticated) {
                return HomeScreenV2();
              } else {
                return Container(color: AppColors.surface);
              }
            },
          ),
        ),
      ),
    );
  }
}
