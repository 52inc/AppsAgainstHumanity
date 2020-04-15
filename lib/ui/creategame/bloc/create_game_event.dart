import 'package:equatable/equatable.dart';

abstract class CreateGameEvent extends Equatable {
  const CreateGameEvent();

  @override
  List<Object> get props => [];
}

class ScreenLoaded extends CreateGameEvent {}

class CardSetSelected extends CreateGameEvent {
  final String cardSet;

  CardSetSelected(this.cardSet);

  @override
  List<Object> get props => [cardSet];
}
