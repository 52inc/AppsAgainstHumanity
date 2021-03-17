import 'package:equatable/equatable.dart';

abstract class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object> get props => [];
}

class LoginWithGooglePressed extends SignInEvent {}
class LoginWithApplePressed extends SignInEvent {}
class LoginAnonymouslyPressed extends SignInEvent {}

class LoginWithEmailPressed extends SignInEvent {
  final String email;
  final String password;

  LoginWithEmailPressed(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class SignUpWithEmailPressed extends SignInEvent {
  final String email;
  final String password;
  final String userName;

  SignUpWithEmailPressed(this.email, this.password, this.userName);

  @override
  List<Object> get props => [email, password, userName];
}
