import 'dart:async';

import 'package:appsagainsthumanity/data/features/users/user_repository.dart';
import 'package:appsagainsthumanity/ui/profile/bloc/profile_event.dart';
import 'package:appsagainsthumanity/ui/profile/bloc/profile_state.dart';
import 'package:bloc/bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository? _userRepository;
  StreamSubscription? _userSubscription;

  ProfileBloc({
    UserRepository? userRepository,
    StreamSubscription? userSubscription,
  })  : _userRepository = userRepository,
        _userSubscription = userSubscription,
        super(ProfileState()) {}

  @override
  ProfileState get initialState => ProfileState();

  @override
  Future<void> close() async {
    super.close();
    await _userSubscription?.cancel();
  }

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is ScreenLoaded) {
      yield* _mapScreenLoadedToState();
    } else if (event is UserLoaded) {
      yield* _mapUserLoadedToState(event);
    } else if (event is DisplayNameChanged) {
      yield* _mapDisplayNameChangedToState(event);
    } else if (event is PhotoChanged) {
      yield* _mapPhotoChangedToState(event);
    } else if (event is DeleteProfilePhoto) {
      yield* _mapDeletePhotoToState();
    }
  }

  Stream<ProfileState> _mapScreenLoadedToState() async* {
    _userSubscription?.cancel();
    _userSubscription = _userRepository?.observeUser().listen((user) {
      add(UserLoaded(user));
    });
  }

  Stream<ProfileState> _mapUserLoadedToState(UserLoaded event) async* {
    yield state.copyWith(user: event.user, isLoading: false, error: null);
  }

  Stream<ProfileState> _mapDisplayNameChangedToState(
      DisplayNameChanged event) async* {
    yield state.copyWith(isLoading: true, error: null);
    try {
      await _userRepository?.updateDisplayName(event.name);
      yield state.copyWith(isLoading: false);
    } catch (e) {
      yield state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Stream<ProfileState> _mapPhotoChangedToState(PhotoChanged event) async* {
    yield state.copyWith(isLoading: true, error: null);
    try {
      final imageBytes = await event.file.readAsBytes();
      await _userRepository?.updateProfilePhoto(imageBytes);
      yield state.copyWith(isLoading: false);
    } catch (e) {
      yield state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Stream<ProfileState> _mapDeletePhotoToState() async* {
    yield state.copyWith(isLoading: true, error: null);
    try {
      await _userRepository?.deleteProfilePhoto();
      yield state.copyWith(isLoading: false);
    } catch (e) {
      yield state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
