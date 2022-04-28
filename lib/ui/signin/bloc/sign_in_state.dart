import 'package:meta/meta.dart';

@immutable
class SignInState {
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;

  SignInState(
      {required this.isSubmitting,
      required this.isSuccess,
      required this.isFailure});

  factory SignInState.empty() {
    return SignInState(
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory SignInState.loading() {
    return SignInState(
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory SignInState.failure() {
    return SignInState(
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
    );
  }

  factory SignInState.success() {
    return SignInState(
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
    );
  }

  SignInState copyWith({
    required bool isSubmitting,
    required bool isSuccess,
    required bool isFailure,
  }) {
    return SignInState(
      isSubmitting: isSubmitting,
      isSuccess: isSuccess,
      isFailure: isFailure,
    );
  }

  @override
  String toString() {
    return '''LoginState {
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
    }''';
  }
}
