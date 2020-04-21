import 'package:appsagainsthumanity/data/features/cards/model/prompt_card.dart';
import 'package:appsagainsthumanity/data/features/cards/model/response_card.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';

part 'turn_winner.g.dart';

@immutable
@JsonSerializable()
class TurnWinner extends Equatable {
  final String playerId;
  final String playerName;
  final String playerAvatarUrl;
  final bool isRandoCardrissian;
  @JsonKey(toJson: promptCardToJson)
  final PromptCard promptCard;

  @JsonKey(toJson: responsesToJson)
  final List<ResponseCard> response;

  TurnWinner({
    this.playerId,
    this.playerName,
    this.playerAvatarUrl,
    this.isRandoCardrissian,
    this.promptCard,
    this.response,
  });

  factory TurnWinner.fromJson(Map<String, dynamic> json) => _$TurnWinnerFromJson(json);

  Map<String, dynamic> toJson() => _$TurnWinnerToJson(this);

  @override
  List<Object> get props => [playerId, playerName, playerAvatarUrl, isRandoCardrissian, promptCard, response];
}

Map<String, dynamic> turnWinnerToJson(TurnWinner turnWinner) => turnWinner?.toJson();

List<Map<String, dynamic>> responsesToJson(List<ResponseCard> cards) => cards?.map((e) => e.toJson())?.toList();
