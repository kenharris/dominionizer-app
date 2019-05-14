import 'dart:async';
import 'dart:math';

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

  void drawNewKingdom() {
    _sink.add(DrawKingdomEvent());
  }

  void sortKingdom(KingdomSortType kst) {
    _sink.add(SortKingdomEvent(kst));
  }

  void exchangeCard(DominionCard card) {
    _sink.add(SwapCardEvent(card));
  }

  void exchangeEventLandmarkProject(DominionCard card) {
    _sink.add(SwapEventLandmarkProjectEvent(card));
  }

  void undoExchange() {
    _sink.add(UndoSwapEvent());
  }

  void _sortCards() {
    switch (_sortType) {
      case KingdomSortType.CardNameDescending:
        _cards.sort((a, b) => b.name.compareTo(a.name));
        _broughtCards.sort((a, b) => b.name.compareTo(a.name));
        _eventsLandmarksProjects.sort((a, b) => b.name.compareTo(a.name));
        break;
      case KingdomSortType.CostAscending:
        _cards.sort((a, b) => a.totalCost.compareTo(b.totalCost));
        _broughtCards.sort((a, b) => a.totalCost.compareTo(b.totalCost));
        _eventsLandmarksProjects
            .sort((a, b) => a.totalCost.compareTo(b.totalCost));
        break;
      case KingdomSortType.CostDescending:
        _cards.sort((a, b) => b.totalCost.compareTo(a.totalCost));
        _broughtCards.sort((a, b) => b.totalCost.compareTo(a.totalCost));
        _eventsLandmarksProjects
            .sort((a, b) => b.totalCost.compareTo(a.totalCost));
        break;
      case KingdomSortType.SetNameAscending:
        _cards.sort((a, b) => a.setName.compareTo(b.setName));
        _broughtCards.sort((a, b) => a.setName.compareTo(b.setName));
        _eventsLandmarksProjects.sort((a, b) => a.setName.compareTo(b.setName));
        break;
      case KingdomSortType.SetNameDescending:
        _cards.sort((a, b) => b.setName.compareTo(a.setName));
        _broughtCards.sort((a, b) => b.setName.compareTo(a.setName));
        _eventsLandmarksProjects.sort((a, b) => b.setName.compareTo(a.setName));
        break;
      default:
        _cards.sort((a, b) => a.name.compareTo(b.name));
        _broughtCards.sort((a, b) => a.name.compareTo(b.name));
        _eventsLandmarksProjects.sort((a, b) => a.name.compareTo(b.name));
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
    var setIds =
        (await _repository.fetchIncludedSets()).map((si) => si.id).toList();
    return await _repository.getEventsLandmarksAndProjects(
        setIds, limit, events, landmarks, projects);
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
      bool autoBlacklist = await _repository.getAutoBlacklist();

      if (autoBlacklist && _cards != null && _cards.length > 0) {
        await _repository.blacklistCards(_cards.map((c) => c.id).toList());
      }

      List<int> setIds =
          (await _repository.fetchIncludedSets()).map((si) => si.id).toList();
      int shuffleSize = await _repository.getShuffleSize();
      _cards = await _repository.drawKingdomCards(setIds, shuffleSize);

      // Check to see if we have categories to satisfy, and if we have done so.
      var categoryValues = await _repository.getCategoryValues();
      if (categoryValues.any((cv) => cv.included)) {
        List<int> missingCategoryIds = List<int>();
        var extraCards = List<DominionCard>();
        var includedCategories = categoryValues.where((cv) => cv.included).toList();
        var categories = await _repository.getCardCategories();
        var includedCategoryNames = includedCategories.map((ic) => categories.where((c) => c.id == ic.id).first.name).toList();

        bool categoryMissing = false;
        for (int i=0; i<includedCategoryNames.length; i++) {
          var categoryName = includedCategoryNames[i];
          if (!_cards.any((c) => c.categories.any((cat) => cat == categoryName))) {
            categoryMissing = true;
          }

          if (categoryMissing) {
            missingCategoryIds.add(includedCategories[i].id);
          }
        }

        List<int> currentCardIds = _cards.map((c) => c.id).toList();
        if (missingCategoryIds.length > 0) {
          extraCards = await _repository.drawCardsOfCategories(missingCategoryIds, currentCardIds);
        }

        int j = 0;
        while (extraCards.length > 0 && j <= _cards.length) {
          if (!_cards[j].categories.any((c) => includedCategoryNames.any((ic) => ic == c))) {
            _cards[j] = extraCards.removeLast();
          }
          j++;
        }
      }

      _broughtCards = await _getBroughtCards(_cards
          .map((dc) => dc.bringsCards ? dc.id : null)
          .where((id) => id != null)
          .toSet()
          .toList());

      Random r = Random();
      int eventsLandmarksProjectsToInclude = r.nextInt((await _repository.getEventsLandmarksProjectsIncluded()) + 1);
      _eventsLandmarksProjects =
          await _getEventsLandmarksAndProjects(eventsLandmarksProjectsToInclude, true, true, true);

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
      List<int> setIds =
          (await _repository.fetchIncludedSets()).map((si) => si.id).toList();
      DominionCard swappedCard =
          await _repository.swapKingdomCard(currentCardIds, setIds);
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
    } else if (event is SwapEventLandmarkProjectEvent) {
      List<int> currentCardIds =
          _eventsLandmarksProjects.map((c) => c.id).toList();
      DominionCard swappedCard = await _repository.swapEventLandmarkProjectCard(
          currentCardIds, true, true, true);
      SwapState newSwapState = SwapState(event.card, swappedCard, false);
      _swapStateController.sink.add(newSwapState);

      _replacedCard = event.card;
      _replacementCard = swappedCard;

      _eventsLandmarksProjects.removeWhere((c) => c.id == event.card.id);
      _eventsLandmarksProjects.add(swappedCard);

      _sortCards();
      newState = KingdomState(
          _cards, false, _sortType, _broughtCards, _eventsLandmarksProjects);
    } else if (event is UndoSwapEvent) {
      if (_eventsLandmarksProjects.any((dc) => dc.id == _replacementCard.id)) {
        _eventsLandmarksProjects
            .removeWhere((c) => c.id == _replacementCard.id);
        _eventsLandmarksProjects.add(_replacedCard);
      } else {
        _cards.removeWhere((c) => c.id == _replacementCard.id);
        _cards.add(_replacedCard);
        _broughtCards = await _getBroughtCards(_cards
            .map((dc) => dc.bringsCards ? dc.id : null)
            .where((id) => id != null)
            .toSet()
            .toList());
      }

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
