import 'package:meta/meta.dart';

import 'package:dominionizer_app/model/dominion_card.dart';

@immutable
class CardDetailsState {
  final List<DominionCard> constituentCards;
  final List<DominionCard> broughtCards;

  CardDetailsState(this.constituentCards, this.broughtCards);
}