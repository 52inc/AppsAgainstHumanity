import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'prompt_card.g.dart';

@immutable
@JsonSerializable()
class PromptCard {
  final String id;
  final String text;
  final String special;
  final String set;
  final String source;

  PromptCard({
    @required this.id,
    @required this.text,
    @required this.special,
    @required this.set,
    @required this.source,
  });

  factory PromptCard.fromJson(Map<String, dynamic> json) => _$PromptCardFromJson(json);

  Map<String, dynamic> toJson() => _$PromptCardToJson(this);
}
