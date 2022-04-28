import 'package:appsagainsthumanity/data/features/game/model/game_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'user_game.g.dart';

@JsonSerializable()
class UserGame {
  @JsonKey(ignore: true)
  String id;
  final String gid;
  final GameState state;
  final DateTime joinedAt;

  UserGame({
    required this.id,
    required this.gid,
    required this.state,
    required this.joinedAt,
  });

  factory UserGame.fromDocument(DocumentSnapshot document) {
    var game = UserGame.fromJson(document.data());
    game.id = document.id;
    return game;
  }

  factory UserGame.fromJson(Map<String, dynamic> json) =>
      _$UserGameFromJson(json);

  Map<String, dynamic> toJson() => _$UserGameToJson(this);
}
