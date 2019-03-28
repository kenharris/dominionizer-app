import 'dart:async';

import 'package:dominionizer_app/blocs/enums/blacklist_enums.dart';
import 'package:dominionizer_app/blocs/events/blacklist_events.dart';
import 'package:dominionizer_app/blocs/states/blacklist_state.dart';
import 'package:dominionizer_app/model/dominion_card.dart';
import 'package:dominionizer_app/resources/repository.dart';

export 'package:dominionizer_app/blocs/enums/blacklist_enums.dart';
export 'package:dominionizer_app/blocs/events/blacklist_events.dart';
export 'package:dominionizer_app/blocs/states/blacklist_state.dart';

class BlacklistBloc {
  BlacklistBloc() {
    _blacklistEventController.stream.listen(_mapEventToState);
    loadBlacklistCards();
  }

  final _repository = Repository();
  final _blacklistStateController =
      StreamController<BlacklistState>.broadcast();
  final _blacklistEventController = StreamController<BlacklistEvent>();

  BlacklistSortType _sortType;
  List<DominionCard> _cards = [];

  Stream<BlacklistState> get blacklistStream =>
      _blacklistStateController.stream;
  Sink<BlacklistEvent> get _sink => _blacklistEventController.sink;

  void loadBlacklistCards() {
    _sink.add(LoadBlacklistEvent());
  }

  void removeCardFromBlacklist(int cardId) {
    _sink.add(BlacklistCardEvent(cardId));
  }

  void sortBlacklist(BlacklistSortType bst) {
    _sink.add(SortBlacklistEvent(bst));
  }

  void emptyBlacklist() {
    _sink.add(EmptyBlacklistEvent());
  }

  void _mapEventToState(BlacklistEvent event) async {
    BlacklistState newState;

    if (event is LoadBlacklistEvent) {
      _cards = await _repository.getBlacklistCards();
      newState = BlacklistState(_cards, BlacklistSortType.CardNameAscending);
    } else if (event is BlacklistCardEvent) {
      int cardId = event.cardId;
      await _repository.removeCardFromBlacklist(cardId);
      _cards = await _repository.getBlacklistCards();
      newState = BlacklistState(_cards, _sortType);
    } else if (event is EmptyBlacklistEvent) {
      _cards = [];
      await _repository.resetBlacklist();
      newState = BlacklistState(_cards, _sortType);
    } else if (event is SortBlacklistEvent) {
      _sortType = event.sortType;
      switch (event.sortType) {
        case BlacklistSortType.CardNameDescending:
          _cards.sort((a, b) => b.name.compareTo(a.name));
          break;
        case BlacklistSortType.SetNameAscending:
          _cards.sort((a, b) => a.setName.compareTo(b.setName));
          break;
        case BlacklistSortType.SetNameDescending:
          _cards.sort((a, b) => b.setName.compareTo(a.setName));
          break;
        default:
          _cards.sort((a, b) => a.name.compareTo(b.name));
      }
      newState = BlacklistState(_cards, _sortType);
    }

    _blacklistStateController.sink.add(newState);
  }

  dispose() {
    _blacklistStateController.close();
    _blacklistEventController.close();
  }
}
