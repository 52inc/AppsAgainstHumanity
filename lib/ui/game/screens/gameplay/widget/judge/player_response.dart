import 'package:appsagainsthumanity/data/features/cards/model/response_card.dart';
import 'package:meta/meta.dart';

@immutable
class PlayerResponse {
    final String playerId;
    final List<ResponseCard> responses;

    PlayerResponse(this.playerId, this.responses);
}
