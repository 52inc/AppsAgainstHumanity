import 'package:appsagainsthumanity/data/features/game/model/game_state.dart';
import 'package:appsagainsthumanity/data/features/game/model/turn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'game.g.dart';

@JsonSerializable()
class Game {
  static const PRIZES_TO_WIN = 7;
  static const PLAYER_LIMIT = 30;

  @JsonKey(ignore: true)
  String id;
  final String gid;
  final String ownerId;
  final GameState state;
  final int round;
  final int prizesToWin;
  final int playerLimit;
  final bool pick2Enabled;
  final bool draw2Pick3Enabled;
  final List<String> judgeRotation;
  final Set<String> cardSets;
  @JsonKey(toJson: _turnToJson)
  final Turn turn;
  final String winner;

  Game({
    required this.id,
    required this.gid,
    required this.ownerId,
    required this.state,
    required this.cardSets,
    this.round = 1,
    this.prizesToWin = PRIZES_TO_WIN,
    this.playerLimit = PLAYER_LIMIT,
    this.pick2Enabled = true,
    this.draw2Pick3Enabled = true,
    required this.judgeRotation,
    required this.turn,
    required this.winner,
  });

  factory Game.fromDocument(DocumentSnapshot snapshot) {
    var game = Game.fromJson(snapshot.data());
    game.id = snapshot.id;
    return game;
  }

  factory Game.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);

  Map<String, dynamic> toJson() => _$GameToJson(this);

  Game copyWith({
    String? id,
    String? gid,
    String? ownerId,
    GameState? state,
    int? round,
    int? prizesToWin,
    List<String>? judgeRotation,
    Set<String>? cardSets,
    Turn? turn,
    String? winner,
  }) {
    return Game(
      id: id ?? this.id,
      gid: gid ?? this.gid,
      ownerId: ownerId ?? this.ownerId,
      state: state ?? this.state,
      round: round ?? this.round,
      prizesToWin: prizesToWin ?? this.prizesToWin,
      judgeRotation: judgeRotation ?? this.judgeRotation,
      cardSets: cardSets ?? this.cardSets,
      turn: turn ?? this.turn,
      winner: winner ?? this.winner,
    );
  }
}

Map<String, dynamic> _turnToJson(Turn turn) => turn.toJson();
