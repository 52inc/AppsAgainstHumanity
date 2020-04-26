import 'package:appsagainsthumanity/data/features/cards/model/card_set.dart';

abstract class CardsRepository{

    /// Get the list of cardsets that you can use
    Future<List<CardSet>> getAvailableCardSets();
}
