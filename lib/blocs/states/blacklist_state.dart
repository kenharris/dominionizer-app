import 'package:dominionizer_app/blocs/enums/blacklist_enums.dart';
import 'package:dominionizer_app/model/dominion_card.dart';

import 'package:meta/meta.dart';

@immutable
class BlacklistState {
  final List<DominionCard> cards;
  final BlacklistSortType sortType;

  BlacklistState(this.cards, this.sortType);
}