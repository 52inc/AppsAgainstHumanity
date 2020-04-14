import 'package:meta/meta.dart';

@immutable
class User {
  final String id;
  final String name;
  final String avatarUrl;
  final DateTime updatedAt;

  User(
      {@required this.id,
      @required this.name,
      @required this.avatarUrl,
      @required this.updatedAt});
}
