import 'package:appsagainsthumanity/data/features/cards/model/card_set.dart';
import 'package:equatable/equatable.dart';

abstract class CreateGameEvent extends Equatable {
  const CreateGameEvent();

  @override
  List<Object> get props => [];
}

class ScreenLoaded extends CreateGameEvent {}

class CardSetSelected extends CreateGameEvent {
  final CardSet cardSet;

  CardSetSelected(this.cardSet);

  @override
  List<Object> get props => [cardSet];
}

class CardSourceSelected extends CreateGameEvent {
  final String source;
  final bool isAllChecked;

  CardSourceSelected(this.source, this.isAllChecked);

  @override
  List<Object> get props => [source, isAllChecked];
}

class ChangePrizesToWin extends CreateGameEvent {
  final int prizesToWin;

  ChangePrizesToWin(this.prizesToWin);

  @override
  List<Object> get props => [prizesToWin];
}

class ChangePlayerLimit extends CreateGameEvent {
  final int playerLimit;

  ChangePlayerLimit(this.playerLimit);

  @override
  List<Object> get props => [playerLimit];
}

class ChangePick2Enabled extends CreateGameEvent {
  final bool enabled;

  ChangePick2Enabled(this.enabled);

  @override
  List<Object> get props => [enabled];
}

class ChangeDraw2Pick3Enabled extends CreateGameEvent {
  final bool enabled;

  ChangeDraw2Pick3Enabled(this.enabled);

  @override
  List<Object> get props => [enabled];
}

class CreateGame extends CreateGameEvent {}
