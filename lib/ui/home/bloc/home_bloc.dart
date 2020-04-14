import 'package:appsagainsthumanity/data/features/users/user_repository.dart';
import 'package:appsagainsthumanity/ui/home/bloc/home_event.dart';
import 'package:appsagainsthumanity/ui/home/bloc/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  UserRepository _userRepository;

  HomeBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  HomeState get initialState => HomeState.loading();

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is HomeStarted) {
        yield* _mapHomeStartedToState();
    }
  }

  Stream<HomeState> _mapHomeStartedToState() async* {
    yield HomeState.loading();
    try {
      var user = await _userRepository.getUser();
      yield HomeState.loaded(user);
    } catch (e, stacktrace) {
      Logger("HomeBloc").fine("Error loading user", e, stacktrace);
      yield HomeState.error(e);
    }
  }
}
