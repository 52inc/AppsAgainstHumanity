import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'response_card.g.dart';

@immutable
@JsonSerializable()
class ResponseCard extends Equatable {
  final String cid;
  final String text;
  final String set;
  final String source;

  ResponseCard({
    @required this.cid,
    @required this.text,
    @required this.set,
    @required this.source,
  });

  factory ResponseCard.fromJson(Map<String, dynamic> json) => _$ResponseCardFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseCardToJson(this);

  @override
  List<Object> get props => [cid, text, set, source];
}

