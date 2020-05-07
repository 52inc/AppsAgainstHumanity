import 'package:appsagainsthumanity/data/features/cards/cache/cards_cache.dart';
import 'package:appsagainsthumanity/data/features/cards/model/card_set.dart';

class InMemoryCardsCache extends CardsCache {
  final List<CardSet> _cardSets = [];

  @override
  Future<List<CardSet>> getCardSets() async {
    return _cardSets;
  }

  @override
  Future<void> setCardSets(List<CardSet> cardSets) async {
    _cardSets.clear();
    _cardSets.addAll(cardSets);
    print("Card sets cached in memory");
  }

  @override
  Future<void> clear() async {
    _cardSets.clear();
  }
}
