import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'prompt_card.g.dart';

@immutable
@JsonSerializable()
class PromptCard extends Equatable {
  final String cid;
  final String text;
  final String special;
  final String set;
  final String source;

  PromptCard({
    required this.cid,
    required this.text,
    required this.special,
    required this.set,
    required this.source,
  });

  factory PromptCard.fromJson(Map<String, dynamic> json) =>
      _$PromptCardFromJson(json);

  Map<String, dynamic> toJson() => _$PromptCardToJson(this);

  @override
  List<Object> get props => [cid, text, special, set, source];

  @override
  String toString() {
    return 'PromptCard{cid: $cid, text: $text, special: $special, set: $set, source: $source}';
  }
}

Map<String, dynamic> promptCardToJson(PromptCard card) => card.toJson();
