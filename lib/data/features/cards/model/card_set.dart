import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'card_set.g.dart';

@JsonSerializable()
class CardSet extends Equatable {
  @JsonKey(ignore: true)
  String? id;

  final String? name;
  final int? prompts;
  final int? responses;
  final String? source;

  CardSet({
    this.id,
    this.name,
    this.prompts,
    this.responses,
    this.source,
  });

  factory CardSet.fromJson(Map<String, dynamic> json) =>
      _$CardSetFromJson(json);

  Map<String, dynamic> toJson() => _$CardSetToJson(this);

  @override
  String toString() {
    return 'CardSet{id: $id, name: $name, prompts: $prompts, responses: $responses, source: $source}';
  }

  @override
  List<Object> get props => [
        id as String,
        name as String,
        prompts as int,
        responses as int,
        source as String,
      ];
}
