import '../model/card.dart';
import '../resources/repository.dart';
import 'package:meta/meta.dart';
import 'dart:async';

abstract class KingdomBlocEvent { }
class RestoreMostRecentKingdomEvent extends KingdomBlocEvent { }
class DrawKingdomEvent extends KingdomBlocEvent {
  final bool autoBlacklist;
  final int shuffleSize;
  final List<int> setIds;

  DrawKingdomEvent({
    @required this.autoBlacklist,
    @required this.shuffleSize,
    this.setIds
  });
}
enum KingdomSortType {
  CardNameAscending,
  CardNameDescending,
  SetNameAscending,
  SetNameDescending,
  CostAscending,
  CostDescending
}
class SortKingdomEvent extends KingdomBlocEvent {
  final KingdomSortType sortType;

  SortKingdomEvent(this.sortType);
}

@immutable
class KingdomBlocState {
  final bool isLoading;
  final List<Card> cards;
  final KingdomSortType sortType;

  KingdomBlocState(this.cards, this.isLoading, this.sortType);
}

class KingdomBloc {
  KingdomBloc()
  {
    _kingdomEventController.stream.listen(_mapEventToState);
    restoreMostRecentKingdom();
  }

  final _repository = Repository();
  final _kingdomStateController = StreamController<KingdomBlocState>.broadcast();
  final _kingdomEventController = StreamController<KingdomBlocEvent>();

  KingdomSortType _sortType;
  List<Card> _cards = [];

  Stream<KingdomBlocState> get kingdomStream => _kingdomStateController.stream;
  Sink<KingdomBlocEvent> get _sink => _kingdomEventController.sink;

  void restoreMostRecentKingdom() {
    _sink.add(RestoreMostRecentKingdomEvent());
  }

  void drawNewKingdom({
    @required autoBlacklist,
    @required shuffleSize,
    setIds
  }) {
    _sink.add(DrawKingdomEvent(shuffleSize: shuffleSize, autoBlacklist: autoBlacklist, setIds: setIds));
  }

  void sortKingdom(KingdomSortType kst) {
    _sink.add(SortKingdomEvent(kst));
  }

  void _mapEventToState(KingdomBlocEvent event) async {
    KingdomBlocState newState;

    if (event is RestoreMostRecentKingdomEvent)
    {
      _cards = await _repository.loadMostRecentKingdom();
      newState = KingdomBlocState(_cards, false, KingdomSortType.CardNameAscending);
    }
    else if (event is DrawKingdomEvent)
    {
      List<int> blacklistIds = await _repository.getBlacklistIds();
      if (event.autoBlacklist && _cards != null && _cards.length > 0) {
        blacklistIds.addAll(_cards.map((c) => c.id));
        await _repository.setBlacklistIds(blacklistIds.toSet().toList());
      }

      _cards = await _repository.fetchCards(sets: event.setIds, limit: event.shuffleSize, shuffle: true, blacklistIds: blacklistIds);
      if (_cards != null && _cards.length > 0)
      {
        _repository.saveMostRecentKingdom(_cards);
      }
      _cards.sort((a,b) => a.name.compareTo(b.name));
      newState = KingdomBlocState(_cards, false, _sortType);
    }
    else if (event is SortKingdomEvent)
    {
      _sortType = event.sortType;
      switch (event.sortType) {
        case KingdomSortType.CardNameDescending:
          _cards.sort((a,b) => b.name.compareTo(a.name));
          break;
        case KingdomSortType.CostAscending:
          _cards.sort((a,b) => a.totalCost.compareTo(b.totalCost));
          break;
        case KingdomSortType.CostDescending:
          _cards.sort((a,b) => b.totalCost.compareTo(a.totalCost));
          break;
        case KingdomSortType.SetNameAscending:
          _cards.sort((a,b) => a.setName.compareTo(b.setName));
          break;
        case KingdomSortType.SetNameDescending:
          _cards.sort((a,b) => b.setName.compareTo(a.setName));
          break;
        default:
          _cards.sort((a,b) => a.name.compareTo(b.name));
      }
      newState = KingdomBlocState(_cards, false, _sortType);
    }

    _kingdomStateController.sink.add(newState);
  }

  dispose() {
    _kingdomStateController.close();
    _kingdomEventController.close();
  }
}