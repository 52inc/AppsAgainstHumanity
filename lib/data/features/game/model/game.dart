import 'package:appsagainsthumanity/data/features/game/model/game_state.dart';
import 'package:appsagainsthumanity/data/features/game/model/turn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kt_dart/kt.dart';
import 'package:meta/meta.dart';

part 'game.g.dart';

@JsonSerializable()
class Game {
  @JsonKey(ignore: true)
  String id;

  @nonNull
  final String gid;

  @nonNull
  final String ownerId;

  @nonNull
  final GameState state;

  @nonNull
  final int round;

  @nonNull
  final int prizesToWin;

  @nonNull
  final Set<String> cardSets;

  @nullable
  final Turn turn;

  @nullable
  final String winner;

  Game({
    this.id,
    @required this.gid,
    @required this.ownerId,
    @required this.state,
    @required this.cardSets,
    this.round = 1,
    this.prizesToWin = 10,
    this.turn,
    this.winner
  });

  factory Game.fromDocument(DocumentSnapshot snapshot) {
    var game = Game.fromJson(snapshot.data);
    game.id = snapshot.documentID;
    return game;
  }

  factory Game.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);

  Map<String, dynamic> toJson() => _$GameToJson(this);
}
