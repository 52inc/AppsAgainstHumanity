part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
    const AuthenticationState();

    @override
    List<Object> get props => [];
}

class Uninitialized extends AuthenticationState {}

class Authenticated extends AuthenticationState {
    final User user;

    const Authenticated(this.user);

    @override
    List<Object> get props => [user];

    @override
    String toString() => 'Authenticated { displayName: ${user.name} }';
}

class Unauthenticated extends AuthenticationState {}
