import 'package:appsagainsthumanity/data/features/cards/cards_repository.dart';
import 'package:appsagainsthumanity/data/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreCardsRepository extends CardsRepository {
  final Firestore _db;

  FirestoreCardsRepository({Firestore firestore})
      : _db = firestore ?? Firestore.instance;

  @override
  Future<List<String>> getAvailableCardSets() {
    return currentUserOrThrow((firebaseUser) async {
       var cardSetsCollection = _db.collection(FirebaseConstants.COLLECTION_CARD_SETS);
       var snapshots = await cardSetsCollection.getDocuments();
       print("${snapshots.documents.length} Card sets found");
       return snapshots.documents.map((e) => e.documentID).toList();
    });
  }
}
