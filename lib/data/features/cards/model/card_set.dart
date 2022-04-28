import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'card_set.g.dart';

@JsonSerializable()
class CardSet extends Equatable {
  @JsonKey(ignore: true)
  final String id;

  final String name;
  final int prompts;
  final int responses;
  final String source;

  CardSet({
    required this.id,
    required this.name,
    required this.prompts,
    required this.responses,
    required this.source,
  });

  factory CardSet.fromJson(Map<String, dynamic> json) =>
      _$CardSetFromJson(json);

  Map<String, dynamic> toJson() => _$CardSetToJson(this);

  @override
  String toString() {
    return 'CardSet{id: $id, name: $name, prompts: $prompts, responses: $responses, source: $source}';
  }

  @override
  List<Object> get props => [id, name, prompts, responses, source];
}
