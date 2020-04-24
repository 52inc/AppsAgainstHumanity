import 'package:appsagainsthumanity/data/features/cards/model/prompt_card.dart';
import 'package:appsagainsthumanity/data/features/cards/model/response_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'player.g.dart';

@immutable
@JsonSerializable()
class Player {
  static const DEFAULT_NAME = "John \"I need a name\" Smith";

  final String id;
  final String name;
  final String avatarUrl;

  @JsonKey(defaultValue: false)
  final bool isRandoCardrissian;

  @JsonKey(defaultValue: false)
  final bool isInactive;

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
    bool isRandoCardrissian = false,
    bool isInactive = false
  }) : isRandoCardrissian = isRandoCardrissian,
        isInactive = isInactive;

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
      isRandoCardrissian: $isRandoCardrissian, 
      isInactive: $isInactive,
      hand: $hand, 
      prizes: $prizes
    }''';
  }
}
