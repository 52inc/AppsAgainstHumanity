import 'dart:async';
import 'package:appsagainsthumanity/data/features/users/user_repository.dart';
import 'package:appsagainsthumanity/internal.dart';
import 'package:appsagainsthumanity/ui/signin/bloc/sign_in_event.dart';
import 'package:appsagainsthumanity/ui/signin/bloc/sign_in_state.dart';
import 'package:bloc/bloc.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  UserRepository _userRepository;

  SignInBloc({@required UserRepository userRepository})
    : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  SignInState get initialState => SignInState.empty();

  @override
  Stream<SignInState> mapEventToState(SignInEvent event) async* {
    if (event is LoginWithGooglePressed) {
      yield* _mapLoginWithGooglePressedToState();
    } else if (event is LoginWithApplePressed) {
      yield* _mapLoginWithApplePressedToState();
    }
  }

  Stream<SignInState> _mapLoginWithGooglePressedToState() async* {
    yield SignInState.loading();
    try {
      await _userRepository.signInWithGoogle();
      await Analytics().logLogin(loginMethod: "google");
      yield SignInState.success();
    } catch (e, stacktrace) {
      Logger("SignInBloc").fine("Error signing in: $e\n$stacktrace");
      yield SignInState.failure();
    }
  }

  Stream<SignInState> _mapLoginWithApplePressedToState() async* {
    yield SignInState.loading();
    try {
      await _userRepository.signInWithApple();
      await Analytics().logLogin(loginMethod: "apple");
      yield SignInState.success();
    } catch (e, stacktrace) {
      Logger("SignInBloc").fine("Error signing in: $e\n$stacktrace");
      yield SignInState.failure();
    }
  }
}
