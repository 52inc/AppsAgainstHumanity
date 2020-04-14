import 'package:appsagainsthumanity/app.dart';
import 'package:appsagainsthumanity/data/app_preferences.dart';
import 'package:appsagainsthumanity/data/features/users/user_repository.dart';
import 'package:appsagainsthumanity/internal/logging_bloc_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'authentication_bloc/authentication_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = LoggingBlocDelegate();
  await AppPreferences.loadInstance();

  runApp(buildRepositoryProvider(BlocProvider(
    create: (context) {
      return AuthenticationBloc(
          userRepository: context.repository<UserRepository>())
        ..add(AppStarted());
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
    ],
    child: child,
  );
}
