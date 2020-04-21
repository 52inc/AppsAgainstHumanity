import 'package:appsagainsthumanity/internal.dart';
import 'package:appsagainsthumanity/ui/home/home_screen.dart';
import 'package:appsagainsthumanity/ui/routes.dart';
import 'package:appsagainsthumanity/ui/signin/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'authentication_bloc/authentication_bloc.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Apps Against Humanity',
      theme: AppThemes.light,
//      darkTheme: AppThemes.dark,
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
        FirebaseAnalyticsObserver(analytics: Analytics.firebaseAnalytics),
        Routes.routeObserver
      ],
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is Unauthenticated) {
            return SignInScreen();
          } else if (state is Authenticated) {
            return HomeScreen();
          } else {
            return Container(color: AppColors.surface);
          }
        },
      ),
    );
  }
}
