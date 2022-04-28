import 'package:appsagainsthumanity/data/features/cards/model/prompt_card.dart';
import 'package:appsagainsthumanity/data/features/cards/model/response_card.dart';
import 'package:appsagainsthumanity/data/features/game/model/turn_winner.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'turn.g.dart';

@immutable
@JsonSerializable()
class Turn {
  final String judgeId;

  @JsonKey(toJson: _promptCardToJson)
  final PromptCard promptCard;

  @JsonKey(toJson: responsesToJson)
  final Map<String, List<ResponseCard>> responses;

  @JsonKey(toJson: turnWinnerToJson)
  final TurnWinner winner;

  Turn({
    required this.judgeId,
    required this.promptCard,
    required this.responses,
    required this.winner,
  });

  factory Turn.fromJson(Map<String, dynamic> json) => _$TurnFromJson(json);

  Map<String, dynamic> toJson() => _$TurnToJson(this);

  Turn copyWith({
    String? judgeId,
    PromptCard? promptCard,
    Map<String, List<ResponseCard>>? responses,
    TurnWinner? winner,
  }) {
    return Turn(
        judgeId: judgeId ?? this.judgeId,
        promptCard: promptCard ?? this.promptCard,
        responses: responses ?? this.responses,
        winner: winner ?? this.winner);
  }
}

Map<String, dynamic> _promptCardToJson(PromptCard card) => card.toJson();

Map<String, dynamic> responsesToJson(
    Map<String, List<ResponseCard>> responses) {
  return responses
      .map((k, e) => MapEntry(k, e.map((e) => e.toJson()).toList()));
}
