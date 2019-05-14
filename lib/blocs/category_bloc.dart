import 'dart:async';

import 'package:dominionizer_app/blocs/enums/category_enums.dart';
import 'package:dominionizer_app/blocs/events/category_events.dart';
import 'package:dominionizer_app/blocs/states/category_state.dart';
import 'package:dominionizer_app/model/dominion_card.dart';
import 'package:dominionizer_app/resources/repository.dart';

export 'package:dominionizer_app/blocs/events/category_events.dart';
export 'package:dominionizer_app/blocs/states/category_state.dart';

class CardCategoryBloc {
  CardCategoryBloc() {
    _categoryEventController.stream.listen(_mapEventToState);
  }

  final _repository = Repository();
  final _categoryStateController = StreamController<CardCategoryState>.broadcast();
  final _categoryEventController = StreamController<CardCategoryEvent>();

  CardCategorySortType _sortType;
  List<DominionCard> _cards = [];

  Stream<CardCategoryState> get categoryStream => _categoryStateController.stream;
  Sink<CardCategoryEvent> get _sink => _categoryEventController.sink;

  void loadCategoryCards(int categoryId) {
    _sink.add(LoadCardCategoryEvent(categoryId));
  }

  void sortCategory(CardCategorySortType bst) {
    _sink.add(SortCardCategoryEvent(bst));
  }

  void _mapEventToState(CardCategoryEvent event) async {
    CardCategoryState newState;

    if (event is LoadCardCategoryEvent) {
      _cards = await _repository.getCategoryCards(event.categoryId);
      newState = CardCategoryState(_cards, CardCategorySortType.CardNameAscending);
    } else if (event is SortCardCategoryEvent) {
      _sortType = event.sortType;
      switch (event.sortType) {
        case CardCategorySortType.CardNameDescending:
          _cards.sort((a, b) => b.name.compareTo(a.name));
          break;
        case CardCategorySortType.SetNameAscending:
          _cards.sort((a, b) => a.setName.compareTo(b.setName));
          break;
        case CardCategorySortType.SetNameDescending:
          _cards.sort((a, b) => b.setName.compareTo(a.setName));
          break;
        default:
          _cards.sort((a, b) => a.name.compareTo(b.name));
      }
      newState = CardCategoryState(_cards, _sortType);
    }

    _categoryStateController.sink.add(newState);
  }

  dispose() {
    _categoryStateController.close();
    _categoryEventController.close();
  }
}
