import 'package:appsagainsthumanity/data/features/cards/model/prompt_card.dart';
import 'package:appsagainsthumanity/data/features/cards/model/response_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'player.g.dart';

@immutable
@JsonSerializable()
class Player {
  final String id;
  final String name;
  final String avatarUrl;

  @JsonKey(includeIfNull: false)
  final List<ResponseCard> hand;

  @JsonKey(includeIfNull: false)
  final List<PromptCard> prizes;

  Player({
    @required this.id,
    @required this.name,
    this.avatarUrl,
    this.hand,
    this.prizes,
  });

  factory Player.fromDocument(DocumentSnapshot documentSnapshot) =>
      Player.fromJson(documentSnapshot.data);

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerToJson(this);

  @override
  String toString() {
    return '''Player { 
      id: $id, 
      name: $name, 
      avatarUrl: $avatarUrl, 
      hand: $hand, 
      prizes: $prizes
    }''';
  }
}
