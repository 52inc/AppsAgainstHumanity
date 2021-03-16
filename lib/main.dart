import 'package:appsagainsthumanity/app.dart';
import 'package:appsagainsthumanity/data/app_preferences.dart';
import 'package:appsagainsthumanity/data/features/cards/cards_repository.dart';
import 'package:appsagainsthumanity/data/features/cards/firestore_cards_repository.dart';
import 'package:appsagainsthumanity/data/features/game/firestore_game_repository.dart';
import 'package:appsagainsthumanity/data/features/game/game_repository.dart';
import 'package:appsagainsthumanity/data/features/users/user_repository.dart';
import 'package:appsagainsthumanity/internal/logging_bloc_delegate.dart';
import 'package:appsagainsthumanity/internal/push.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'authentication_bloc/authentication_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = LoggingBlocDelegate();
  await AppPreferences.loadInstance();
  await Firebase.initializeApp();

  // Setup logger
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  // Setup Push Notifications
  PushNotifications().setup();

  runApp(buildRepositoryProvider(BlocProvider(
    create: (context) {
      return AuthenticationBloc(
        userRepository: context.repository<UserRepository>(),
        preferences: AppPreferences()
      )..add(AppStarted());
    },
    child: App(),
  )));
}

Widget buildRepositoryProvider(Widget child) {
  return MultiRepositoryProvider(
    providers: [
      RepositoryProvider<UserRepository>(
        create: (context) => UserRepository(),
      ),
      RepositoryProvider<CardsRepository>(
        create: (context) => FirestoreCardsRepository(),
      ),
      RepositoryProvider<GameRepository>(
        create: (context) => FirestoreGameRepository(userRepository: context.repository()),
      )
    ],
    child: child,
  );
}
