import 'package:appsagainsthumanity/data/features/users/model/user.dart';
import 'package:meta/meta.dart';

@immutable
class ProfileState {
  final bool isLoading;
  final String error;
  final User user;

  ProfileState({
    this.isLoading = true,
    this.error,
    this.user,
  });

  ProfileState copyWith({
    bool isLoading,
    String error,
    User user,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      user: user ?? this.user,
    );
  }

  @override
  String toString() {
    return 'ProfileState{isLoading: $isLoading, error: $error, user: $user}';
  }
}
