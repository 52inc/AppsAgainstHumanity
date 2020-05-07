import 'package:appsagainsthumanity/data/features/cards/model/card_set.dart';

abstract class CardsCache {

    Future<List<CardSet>> getCardSets();
    Future<void> setCardSets(List<CardSet> cardSets);
    Future<void> clear();
}
