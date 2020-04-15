import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'response_card.g.dart';

@immutable
@JsonSerializable()
class ResponseCard {
  final String id;
  final String text;
  final String set;
  final String source;

  ResponseCard({
    @required this.id,
    @required this.text,
    @required this.set,
    @required this.source,
  });

  factory ResponseCard.fromJson(Map<String, dynamic> json) => _$ResponseCardFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseCardToJson(this);
}
