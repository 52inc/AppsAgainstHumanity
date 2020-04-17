import 'package:appsagainsthumanity/data/features/cards/model/prompt_card.dart';
import 'package:appsagainsthumanity/data/features/cards/model/response_card.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kt_dart/kt.dart';
import 'package:meta/meta.dart';

part 'turn.g.dart';

@immutable
@JsonSerializable()
class Turn {
  @nonNull
  final String judgeId;

  @nonNull
  final PromptCard promptCard;

  @nonNull
  final Map<String, Set<ResponseCard>> responses;

  @nonNull
  @JsonKey(nullable: true)
  final Set<String> downvotes;

  @nullable
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
}
