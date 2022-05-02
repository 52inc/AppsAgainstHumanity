import 'package:appsagainsthumanity/data/features/cards/cache/cards_cache.dart';
import 'package:appsagainsthumanity/data/features/cards/cache/in_memory_cards_cache.dart';
import 'package:appsagainsthumanity/data/features/cards/cards_repository.dart';
import 'package:appsagainsthumanity/data/features/cards/model/card_set.dart';
import 'package:appsagainsthumanity/data/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreCardsRepository extends CardsRepository {
  FirebaseFirestore? db;
  CardsCache? cache;

  FirestoreCardsRepository({
    this.db,
    this.cache,
  }) : super() {
    db = FirebaseFirestore.instance;
    cache = InMemoryCardsCache();
  }

  @override
  Future<List<CardSet>> getAvailableCardSets() {
    return currentUserOrThrow((firebaseUser) async {
      // Check and return cache if valid
      final cachedSets = await cache!.getCardSets();
      if (cachedSets.isNotEmpty) {
        return cachedSets;
      } else {
        var cardSetsCollection =
            db!.collection(FirebaseConstants.COLLECTION_CARD_SETS);
        var snapshots = await cardSetsCollection.get();
        print("${snapshots.docs.length} Card sets found");
        final cardSets = snapshots.docs.map((e) {
          var cardSet = CardSet.fromJson(e.data());
          cardSet.id = e.id;
          return cardSet;
        }).toList();
        await cache!.setCardSets(cardSets);
        return cardSets;
      }
    });
  }
}
