import 'package:dominionizer_app/blocs/enums/category_enums.dart';

abstract class CardCategoryEvent {}

class LoadCardCategoryEvent extends CardCategoryEvent {
  final int categoryId;

  LoadCardCategoryEvent(this.categoryId);
}

class SortCardCategoryEvent extends CardCategoryEvent {
  final CardCategorySortType sortType;

  SortCardCategoryEvent(this.sortType);
}
