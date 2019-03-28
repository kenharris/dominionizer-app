import 'dart:async';

import 'package:dominionizer_app/blocs/enums/kingdom_enums.dart';
import 'package:dominionizer_app/blocs/events/kingdom_events.dart';
import 'package:dominionizer_app/blocs/states/kingdom_state.dart';
import 'package:dominionizer_app/model/dominion_card.dart';
import 'package:dominionizer_app/resources/repository.dart';

export 'package:dominionizer_app/blocs/enums/kingdom_enums.dart';
export 'package:dominionizer_app/blocs/events/kingdom_events.dart';
export 'package:dominionizer_app/blocs/states/kingdom_state.dart';

import 'package:meta/meta.dart';

class KingdomBloc {
  KingdomBloc() {
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

  void drawNewKingdom(
      {@required autoBlacklist, @required shuffleSize, setIds}) {
    _sink.add(DrawKingdomEvent(
        shuffleSize: shuffleSize,
        autoBlacklist: autoBlacklist,
        setIds: setIds));
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
        _cards.sort((a, b) => b.name.compareTo(a.name));
        break;
      case KingdomSortType.CostAscending:
        _cards.sort((a, b) => a.totalCost.compareTo(b.totalCost));
        break;
      case KingdomSortType.CostDescending:
        _cards.sort((a, b) => b.totalCost.compareTo(a.totalCost));
        break;
      case KingdomSortType.SetNameAscending:
        _cards.sort((a, b) => a.setName.compareTo(b.setName));
        break;
      case KingdomSortType.SetNameDescending:
        _cards.sort((a, b) => b.setName.compareTo(a.setName));
        break;
      default:
        _cards.sort((a, b) => a.name.compareTo(b.name));
    }
  }

  Future<List<DominionCard>> _getBroughtCards(List<int> cardIds) async {
    List<DominionCard> broughtCards = [];
    if (cardIds != null && cardIds.length > 0) {
      broughtCards = await _repository.getBroughtCards(cardIds);
    }
    return broughtCards;
  }

  Future<List<DominionCard>> _getEventsLandmarksAndProjects(
      int limit, bool events, bool landmarks, bool projects) async {
    return await _repository.getEventsLandmarksAndProjects(
        limit, events, landmarks, projects);
  }

  void _mapEventToState(KingdomBlocEvent event) async {
    KingdomState newState;

    if (event is RestoreMostRecentKingdomEvent) {
      newState = await _repository.loadMostRecentKingdom();

      _cards = newState.cards;
      _broughtCards = newState.broughtCards;
      _eventsLandmarksProjects = newState.eventsLandmarksProjects;
      _sortType = newState.sortType;

      // newState = KingdomState(_cards, false, KingdomSortType.CardNameAscending, _broughtCards, _eventsLandmarksProjects);
    } else if (event is DrawKingdomEvent) {
      if (event.autoBlacklist && _cards != null && _cards.length > 0) {
        await _repository.blacklistCards(_cards.map((c) => c.id).toList());
      }

      _cards =
          await _repository.drawKingdomCards(event.setIds, event.shuffleSize);
      _broughtCards = await _getBroughtCards(_cards
          .map((dc) => dc.bringsCards ? dc.id : null)
          .where((id) => id != null)
          .toSet()
          .toList());
      _eventsLandmarksProjects =
          await _getEventsLandmarksAndProjects(2, true, true, true);

      _cards.sort((a, b) => a.name.compareTo(b.name));
      newState = KingdomState(
          _cards, false, _sortType, _broughtCards, _eventsLandmarksProjects);
      _repository.saveMostRecentKingdom(newState);
    } else if (event is SortKingdomEvent) {
      _sortType = event.sortType;
      _sortCards();
      newState = KingdomState(
          _cards, false, _sortType, _broughtCards, _eventsLandmarksProjects);
    } else if (event is SwapCardEvent) {
      List<int> currentCardIds = _cards.map((c) => c.id).toList();
      DominionCard swappedCard =
          await _repository.swapKingdomCard(currentCardIds, event.setIds);
      SwapState newSwapState = SwapState(event.card, swappedCard, false);
      _swapStateController.sink.add(newSwapState);

      _replacedCard = event.card;
      _replacementCard = swappedCard;

      _cards.removeWhere((c) => c.id == event.card.id);
      _cards.add(swappedCard);
      _broughtCards = await _getBroughtCards(_cards
          .map((dc) => dc.bringsCards ? dc.id : null)
          .where((id) => id != null)
          .toSet()
          .toList());
      _sortCards();
      newState = KingdomState(
          _cards, false, _sortType, _broughtCards, _eventsLandmarksProjects);
    } else if (event is UndoSwapEvent) {
      _cards.removeWhere((c) => c.id == _replacementCard.id);
      _cards.add(_replacedCard);
      _broughtCards = await _getBroughtCards(_cards
          .map((dc) => dc.bringsCards ? dc.id : null)
          .where((id) => id != null)
          .toSet()
          .toList());
      _sortCards();

      SwapState newSwapState = SwapState(_replacementCard, _replacedCard, true);
      _swapStateController.sink.add(newSwapState);
      newState = KingdomState(
          _cards,
          false,
          _sortType ?? KingdomSortType.CardNameAscending,
          _broughtCards,
          _eventsLandmarksProjects);
    }

    _kingdomStateController.sink.add(newState);
  }

  dispose() {
    _kingdomStateController.close();
    _kingdomEventController.close();
    _swapStateController.close();
  }
}
