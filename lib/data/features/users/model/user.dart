import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'user.g.dart';

@immutable
@JsonSerializable()
class User {
  final String id;
  final String name;
  final String avatarUrl;
  final DateTime updatedAt;

  User({
    @required this.id,
    @required this.name,
    @required this.avatarUrl,
    @required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
