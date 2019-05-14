import 'package:dominionizer_app/blocs/enums/category_enums.dart';
import 'package:dominionizer_app/model/dominion_card.dart';

import 'package:meta/meta.dart';

@immutable
class CardCategoryState {
  final List<DominionCard> cards;
  final CardCategorySortType sortType;

  CardCategoryState(this.cards, this.sortType);
}