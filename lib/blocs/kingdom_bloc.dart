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

const List<String> KingdomSortTypeNames = [
  "Card Name Ascending",
  "Card Name Descending",
  "Set Name Ascending",
  "Set Name Descending",
  "Cost Ascending",
  "Cost Descending"
];

@immutable
class KingdomBlocState {
  final bool isLoading;
  final List<DominionCard> cards;
  final KingdomSortType sortType;

  KingdomBlocState(this.cards, this.isLoading, this.sortType);
}

@immutable
class SwapState {
  final DominionCard initialCard;
  final DominionCard swappedCard;
  final bool wasUndo;

  SwapState(this.initialCard, this.swappedCard, this.wasUndo);
}

class SwapCardEvent extends KingdomBlocEvent {
  final DominionCard card;

  SwapCardEvent(this.card);
}
class UndoSwapEvent extends KingdomBlocEvent { }

class KingdomBloc {
  KingdomBloc()
  {
    _kingdomEventController.stream.listen(_mapEventToState);
    restoreMostRecentKingdom();
  }

  final _repository = Repository();
  
  final _kingdomStateController = StreamController<KingdomBlocState>.broadcast();
  final _kingdomEventController = StreamController<KingdomBlocEvent>();
  Stream<KingdomBlocState> get kingdomStream => _kingdomStateController.stream;
  Sink<KingdomBlocEvent> get _sink => _kingdomEventController.sink;

  KingdomSortType _sortType;
  List<DominionCard> _cards = [];
  DominionCard _replacedCard;
  DominionCard _replacementCard;

  final _swapStateController = StreamController<SwapState>.broadcast();
  Stream<SwapState> get swapStream => _swapStateController.stream;

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

  void exchangeCard(DominionCard card) {
    _sink.add(SwapCardEvent(card));
  }

  void undoExchange() {
    _sink.add(UndoSwapEvent());
  }

  void _sortCards() {
    switch (_sortType) {
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
      _sortCards();
      newState = KingdomBlocState(_cards, false, _sortType);
    }
    else if (event is SwapCardEvent)
    {
      List<int> blacklistIds = await _repository.getBlacklistIds();
      List<int> currentCardIds = _cards.map((c) => c.id).toList();
      currentCardIds.remove(event.card.id);
      blacklistIds.addAll(currentCardIds);
      DominionCard swappedCard = (await _repository.fetchCards(blacklistIds: blacklistIds.toSet().toList(), limit: 1, shuffle: true)).first;
      SwapState newSwapState = SwapState(event.card, swappedCard, false);
      _swapStateController.sink.add(newSwapState);

      _replacedCard = event.card;
      _replacementCard = swappedCard;

      _cards.removeWhere((c) => c.id == event.card.id);
      _cards.add(swappedCard);
      _sortCards();
      newState = KingdomBlocState(_cards, false, _sortType);
    }
    else if (event is UndoSwapEvent)
    {
      _cards.removeWhere((c) => c.id == _replacementCard.id);
      _cards.add(_replacedCard);
      _sortCards();

      SwapState newSwapState = SwapState(_replacementCard, _replacedCard, true);
      _swapStateController.sink.add(newSwapState);
      newState = KingdomBlocState(_cards, false, _sortType ?? KingdomSortType.CardNameAscending);
    }

    _kingdomStateController.sink.add(newState);
  }

  dispose() {
    _kingdomStateController.close();
    _kingdomEventController.close();
    _swapStateController.close();
  }
}