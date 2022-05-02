import 'package:appsagainsthumanity/data/features/cards/model/prompt_card.dart';
import 'package:appsagainsthumanity/data/features/cards/model/response_card.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';

part 'turn_winner.g.dart';

@immutable
@JsonSerializable()
class TurnWinner extends Equatable {
  final String? playerId;
  final String? playerName;
  final String? playerAvatarUrl;
  final bool? isRandoCardrissian;
  @JsonKey(toJson: promptCardToJson)
  final PromptCard? promptCard;

  @JsonKey(toJson: responsesToJson)
  final List<ResponseCard>? response;

  @JsonKey(toJson: playerResponsesToJson)
  final Map<String, List<ResponseCard>>? responses;

  TurnWinner({
    this.playerId,
    this.playerName,
    this.playerAvatarUrl,
    this.isRandoCardrissian,
    this.promptCard,
    this.response,
    this.responses,
  });

  factory TurnWinner.fromJson(Map<String, dynamic> json) =>
      _$TurnWinnerFromJson(json);

  Map<String, dynamic> toJson() => _$TurnWinnerToJson(this);

  @override
  String toString() {
    return 'TurnWinner{playerId: $playerId, playerName: $playerName, playerAvatarUrl: $playerAvatarUrl, '
        'isRandoCardrissian: $isRandoCardrissian, promptCard: $promptCard, response: $response, responses: $responses}';
  }

  @override
  List<Object> get props => [
        playerId as String,
        playerName as String,
        playerAvatarUrl as String,
        isRandoCardrissian as bool,
        promptCard as PromptCard,
        response as List<ResponseCard>,
        responses as Map<String, List<ResponseCard>>,
      ];
}

Map<String, dynamic> turnWinnerToJson(TurnWinner turnWinner) =>
    turnWinner.toJson();

List<Map<String, dynamic>> responsesToJson(List<ResponseCard> cards) =>
    cards.map((e) => e.toJson()).toList();

Map<String, dynamic> playerResponsesToJson(
    Map<String, List<ResponseCard>> responses) {
  return responses
      .map((k, e) => MapEntry(k, e.map((e) => e.toJson()).toList()));
}
