import 'dart:convert';

import '../model/dominion_card.dart';
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
class KingdomState {
  final bool isLoading;
  final List<DominionCard> cards;
  final List<DominionCard> broughtCards;
  final List<DominionCard> eventsLandmarksProjects;
  final KingdomSortType sortType;

  int get totalCards => (cards?.length ?? 0) + (broughtCards?.length ?? 0) + (eventsLandmarksProjects?.length ?? 0);
  int get numberOfKingdomCards => cards?.length ?? 0;
  int get numberOfBroughtCards => broughtCards?.length ?? 0;

  KingdomState(this.cards, this.isLoading, this.sortType, this.broughtCards, this.eventsLandmarksProjects);

  String toJson() {
    Map<String, dynamic> _map = {
      'cards' : cards,
      'broughtCards' : broughtCards,
      'eventsLandmarksProjects' : eventsLandmarksProjects,
      'sortType' : sortType?.index ?? KingdomSortType.CardNameAscending.index
    };
    String ret = jsonEncode(_map);
    return ret;
  }

  KingdomState.fromJson(Map<String, dynamic> json)
    : cards = (json['cards'] as List)?.map((dc) => DominionCard.fromJson(jsonDecode(dc)))?.toList() ?? [],
      broughtCards = (json['broughtCards'] as List)?.map((dc) => DominionCard.fromJson(jsonDecode(dc)))?.toList() ?? [],
      eventsLandmarksProjects = (json['eventsLandmarksProjects'] as List)?.map((dc) => DominionCard.fromJson(jsonDecode(dc)))?.toList() ?? [],
      sortType = KingdomSortType.values[json['sortType'] ?? KingdomSortType.CardNameAscending.index],
      isLoading = false;
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
  final List<int> setIds;

  SwapCardEvent(this.card, this.setIds);
}
class UndoSwapEvent extends KingdomBlocEvent { }

class KingdomBloc {
  KingdomBloc()
  {
    _kingdomEventController.stream.listen(_mapEventToState);
    restoreMostRecentKingdom();
  }

  final _repository = Repository();
  
  final _kingdomStateController = StreamController<KingdomState>.broadcast();
  final _kingdomEventController = StreamController<KingdomBlocEvent>();
  Stream<KingdomState> get kingdomStream => _kingdomStateController.stream;
  Sink<KingdomBlocEvent> get _sink => _kingdomEventController.sink;

  KingdomSortType _sortType;
  List<DominionCard> _cards = [];
  List<DominionCard> _broughtCards = [];
  List<DominionCard> _eventsLandmarksProjects = [];
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

  void exchangeCard(DominionCard card, List<int> setIds) {
    _sink.add(SwapCardEvent(card, setIds));
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

  Future<List<DominionCard>> _getBroughtCards(List<int> cardIds) async {
    List<DominionCard> broughtCards = [];
    if (cardIds != null && cardIds.length > 0)
    {
      broughtCards = await _repository.getBroughtCards(cardIds);
    }
    return broughtCards;
  }

  Future<List<DominionCard>> _getEventsLandmarksAndProjects(int limit, bool events, bool landmarks, bool projects) async {
    return await _repository.getEventsLandmarksAndProjects(limit, events, landmarks, projects);
  }

  void _mapEventToState(KingdomBlocEvent event) async {
    KingdomState newState;

    if (event is RestoreMostRecentKingdomEvent)
    {
      newState = await _repository.loadMostRecentKingdom();
      
      _cards = newState.cards;
      _broughtCards = newState.broughtCards;
      _eventsLandmarksProjects = newState.eventsLandmarksProjects;
      _sortType = newState.sortType;

      // newState = KingdomState(_cards, false, KingdomSortType.CardNameAscending, _broughtCards, _eventsLandmarksProjects);
    }
    else if (event is DrawKingdomEvent)
    {
      List<int> blacklistIds = await _repository.getBlacklistIds();
      if (event.autoBlacklist && _cards != null && _cards.length > 0) {
        blacklistIds.addAll(_cards.map((c) => c.id));
        await _repository.setBlacklistIds(blacklistIds.toSet().toList());
      }

      _cards = await _repository.fetchCards(sets: event.setIds, limit: event.shuffleSize, shuffle: true, blacklistIds: blacklistIds);
      _broughtCards = await _getBroughtCards(_cards.map((dc) => dc.bringsCards ? dc.id : null).where((id) => id != null).toSet().toList());
      _eventsLandmarksProjects = await _getEventsLandmarksAndProjects(2, true, true, true);

      _cards.sort((a,b) => a.name.compareTo(b.name));
      newState = KingdomState(_cards, false, _sortType, _broughtCards, _eventsLandmarksProjects);
      _repository.saveMostRecentKingdom(newState);
    }
    else if (event is SortKingdomEvent)
    {
      _sortType = event.sortType;
      _sortCards();
      newState = KingdomState(_cards, false, _sortType, _broughtCards, _eventsLandmarksProjects);
    }
    else if (event is SwapCardEvent)
    {
      List<int> blacklistIds = await _repository.getBlacklistIds();
      List<int> currentCardIds = _cards.map((c) => c.id).toList();
      currentCardIds.remove(event.card.id);
      blacklistIds.addAll(currentCardIds);
      DominionCard swappedCard = (await _repository.fetchCards(blacklistIds: blacklistIds.toSet().toList(), limit: 1, shuffle: true, sets: event.setIds)).first;
      SwapState newSwapState = SwapState(event.card, swappedCard, false);
      _swapStateController.sink.add(newSwapState);

      _replacedCard = event.card;
      _replacementCard = swappedCard;

      _cards.removeWhere((c) => c.id == event.card.id);
      _cards.add(swappedCard);
      _broughtCards = await _getBroughtCards(_cards.map((dc) => dc.bringsCards ? dc.id : null).where((id) => id != null).toSet().toList());
      _sortCards();
      newState = KingdomState(_cards, false, _sortType, _broughtCards, _eventsLandmarksProjects);
    }
    else if (event is UndoSwapEvent)
    {
      _cards.removeWhere((c) => c.id == _replacementCard.id);
      _cards.add(_replacedCard);
      _broughtCards = await _getBroughtCards(_cards.map((dc) => dc.bringsCards ? dc.id : null).where((id) => id != null).toSet().toList());
      _sortCards();

      SwapState newSwapState = SwapState(_replacementCard, _replacedCard, true);
      _swapStateController.sink.add(newSwapState);
      newState = KingdomState(_cards, false, _sortType ?? KingdomSortType.CardNameAscending, _broughtCards, _eventsLandmarksProjects);
    }

    _kingdomStateController.sink.add(newState);
  }

  dispose() {
    _kingdomStateController.close();
    _kingdomEventController.close();
    _swapStateController.close();
  }
}