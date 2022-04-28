import 'dart:async';
import 'package:appsagainsthumanity/data/features/users/user_repository.dart';
import 'package:appsagainsthumanity/internal.dart';
import 'package:appsagainsthumanity/ui/signin/bloc/sign_in_event.dart';
import 'package:appsagainsthumanity/ui/signin/bloc/sign_in_state.dart';
import 'package:bloc/bloc.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  UserRepository userRepository;

  // This prob ain't right
  SignInBloc({required this.userRepository})
      : super(
          SignInState(
            isSuccess: true,
            isFailure: false,
            isSubmitting: false,
          ),
        ) {
    userRepository = UserRepository();
  }

  @override
  SignInState get initialState => SignInState.empty();

  @override
  Stream<SignInState> mapEventToState(SignInEvent event) async* {
    if (event is LoginWithGooglePressed) {
      yield* _mapLoginWithGooglePressedToState();
    } else if (event is LoginWithApplePressed) {
      yield* _mapLoginWithApplePressedToState();
    } else if (event is LoginAnonymouslyPressed) {
      yield* _mapLoginAnonymouslyPressedToState();
    } else if (event is LoginWithEmailPressed) {
      yield* _mapLoginWithEmailPressedToState(event);
    } else if (event is SignUpWithEmailPressed) {
      yield* _mapSignUpWithEmailPressedToState(event);
    }
  }

  Stream<SignInState> _mapLoginWithGooglePressedToState() async* {
    yield SignInState.loading();
    try {
      await userRepository.signInWithGoogle();
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
      await userRepository.signInWithApple();
      await Analytics().logLogin(loginMethod: "apple");
      yield SignInState.success();
    } catch (e, stacktrace) {
      Logger("SignInBloc").fine("Error signing in: $e\n$stacktrace");
      yield SignInState.failure();
    }
  }

  Stream<SignInState> _mapLoginAnonymouslyPressedToState() async* {
    yield SignInState.loading();
    try {
      await userRepository.signInAnonymously();
      await Analytics().logLogin(loginMethod: "anonymously");
      yield SignInState.success();
    } catch (e, stacktrace) {
      Logger("SignInBloc").fine("Error signing in: $e\n$stacktrace");
      yield SignInState.failure();
    }
  }

  Stream<SignInState> _mapLoginWithEmailPressedToState(
      LoginWithEmailPressed event) async* {
    yield SignInState.loading();
    try {
      await userRepository.signInWithEmail(event.email, event.password);
      await Analytics().logLogin(loginMethod: "email");
      yield SignInState.success();
    } catch (e, stacktrace) {
      Logger("SignInBloc").fine("Error signing in: $e\n$stacktrace");
      yield SignInState.failure();
    }
  }

  Stream<SignInState> _mapSignUpWithEmailPressedToState(
      SignUpWithEmailPressed event) async* {
    yield SignInState.loading();
    try {
      await userRepository.signUpWithEmail(
          event.email, event.password, event.userName);
      await Analytics().logSignUp(signUpMethod: "email");
      yield SignInState.success();
    } catch (e, stacktrace) {
      Logger("SignInBloc").fine("Error signing in: $e\n$stacktrace");
      yield SignInState.failure();
    }
  }
}
