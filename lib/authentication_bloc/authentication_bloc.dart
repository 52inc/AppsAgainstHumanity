import 'dart:async';
import 'package:appsagainsthumanity/data/app_preferences.dart';
import 'package:appsagainsthumanity/data/features/users/model/user.dart';
import 'package:appsagainsthumanity/data/features/users/user_repository.dart';
import 'package:appsagainsthumanity/internal.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

part 'authentication_event.dart';

part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;
  final AppPreferences _preferences;

  AuthenticationBloc({@required UserRepository userRepository, @required AppPreferences preferences})
      : assert(userRepository != null),
        assert(preferences != null),
        _userRepository = userRepository,
        _preferences = preferences;

  @override
  AuthenticationState get initialState => Uninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    } else if (event is AgreeToTerms) {
      yield* _mapAgreeToTermsToState();
    }
  }

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    try {
      final isSignedIn = await _userRepository.isSignedIn();
      if (isSignedIn) {
        Logger("authentication_bloc").fine("User is signed-in!");
        final user = await _userRepository.getUser();
        if (_preferences.agreedToTermsOfService) {
          yield Authenticated(user);
        } else {
          yield NeedsAgreeToTerms();
        }
      } else {
        yield Unauthenticated();
      }
    } catch (_) {
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState() async* {
    if (_preferences.agreedToTermsOfService) {
      yield Authenticated(await _userRepository.getUser());
    } else {
      yield NeedsAgreeToTerms();
    }
  }

  Stream<AuthenticationState> _mapAgreeToTermsToState() async* {
    _preferences.agreedToTermsOfService = true;
    yield Authenticated(await _userRepository.getUser());
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    yield Unauthenticated();
    await Analytics().logEvent(name: "logout");
    _userRepository.signOut();
  }
}
