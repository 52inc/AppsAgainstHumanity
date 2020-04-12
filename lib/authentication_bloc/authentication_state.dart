part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
    const AuthenticationState();

    @override
    List<Object> get props => [];
}

class Uninitialized extends AuthenticationState {}

class Authenticated extends AuthenticationState {
    final FirebaseUser firebaseUser;

    const Authenticated(this.firebaseUser);

    @override
    List<Object> get props => [firebaseUser];

    @override
    String toString() => 'Authenticated { displayName: ${firebaseUser.displayName} }';
}

class Unauthenticated extends AuthenticationState {}
