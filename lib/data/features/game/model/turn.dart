import 'package:appsagainsthumanity/data/features/cards/model/prompt_card.dart';
import 'package:appsagainsthumanity/data/features/cards/model/response_card.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kt_dart/kt.dart';
import 'package:meta/meta.dart';

part 'turn.g.dart';

@immutable
@JsonSerializable()
class Turn {
  final String judgeId;

  @JsonKey(toJson: _promptCardToJson)
  final PromptCard promptCard;

  @JsonKey(toJson: _responsesToJson)
  final Map<String, Set<ResponseCard>> responses;

  @JsonKey(nullable: true)
  final Set<String> downvotes;
  final String winnerId;

  Turn({
    @required this.judgeId,
    @required this.promptCard,
    @required this.responses,
    Set<String> downvotes,
    this.winnerId,
  }) : downvotes = downvotes;

  factory Turn.fromJson(Map<String, dynamic> json) => _$TurnFromJson(json);

  Map<String, dynamic> toJson() => _$TurnToJson(this);

  Turn copyWith({
    String judgeId,
    PromptCard promptCard,
    Map<String, Set<ResponseCard>> responses,
    Set<String> downvotes,
    String winnerId,
  }) {
    return Turn(
        judgeId: judgeId ?? this.judgeId,
        promptCard: promptCard ?? this.promptCard,
        responses: responses ?? this.responses,
        downvotes: downvotes ?? this.downvotes,
        winnerId: winnerId ?? this.winnerId);
  }
}

Map<String, dynamic> _promptCardToJson(PromptCard card) => card.toJson();

Map<String, dynamic> _responsesToJson(Map<String, Set<ResponseCard>> responses) {
  return responses?.map((k, e) => MapEntry(k, e.map((e) => e.toJson()).toList()));
}
