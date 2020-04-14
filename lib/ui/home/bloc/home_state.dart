import 'package:appsagainsthumanity/data/features/users/model/user.dart';
import 'package:meta/meta.dart';

@immutable
class HomeState {
  final User user;
  final String error;
  final bool isLoading;

  HomeState({
    @required this.user,
    @required this.isLoading,
    this.error,
  });

  factory HomeState.loading() {
    return HomeState(
      user: null,
      isLoading: true,
      error: null,
    );
  }

  factory HomeState.loaded(User user) {
    return HomeState(
      user: user,
      isLoading: false,
      error: null,
    );
  }

  factory HomeState.error(String description) {
    return HomeState(
      isLoading: false,
      error: description,
    );
  }

  HomeState copyWith({
    User user,
    bool isLoading,
    String error,
  }) {
    return HomeState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  String toString() {
    return '''HomeState {
      user: $user,
      isLoading: $isLoading,
      error: $error
    }''';
  }
}
