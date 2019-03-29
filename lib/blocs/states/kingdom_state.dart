import 'dart:convert';

import 'package:dominionizer_app/blocs/enums/kingdom_enums.dart';
import 'package:dominionizer_app/blocs/events/kingdom_events.dart';
import 'package:dominionizer_app/model/dominion_card.dart';
import 'package:meta/meta.dart';

@immutable
class KingdomState {
  final bool isLoading;
  final List<DominionCard> cards;
  final List<DominionCard> broughtCards;
  final List<DominionCard> eventsLandmarksProjects;
  final KingdomSortType sortType;

  int get totalCards =>
      (cards?.length ?? 0) +
      (broughtCards?.length ?? 0) +
      (eventsLandmarksProjects?.length ?? 0);
  int get numberOfKingdomCards => cards?.length ?? 0;
  int get numberOfBroughtCards => broughtCards?.length ?? 0;

  KingdomState(this.cards, this.isLoading, this.sortType, this.broughtCards,
      this.eventsLandmarksProjects);

  String toJson() {
    Map<String, dynamic> _map = {
      'cards': cards,
      'broughtCards': broughtCards,
      'eventsLandmarksProjects': eventsLandmarksProjects,
      'sortType': sortType?.index ?? KingdomSortType.CardNameAscending.index
    };
    String ret = jsonEncode(_map);
    return ret;
  }

  KingdomState.fromJson(Map<String, dynamic> json)
      : cards = (json['cards'] as List)
                ?.map((dc) => DominionCard.fromJson(jsonDecode(dc)))
                ?.toList() ??
            [],
        broughtCards = (json['broughtCards'] as List)
                ?.map((dc) => DominionCard.fromJson(jsonDecode(dc)))
                ?.toList() ??
            [],
        eventsLandmarksProjects = (json['eventsLandmarksProjects'] as List)
                ?.map((dc) => DominionCard.fromJson(jsonDecode(dc)))
                ?.toList() ??
            [],
        sortType = KingdomSortType.values[
            json['sortType'] ?? KingdomSortType.CardNameAscending.index],
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

  SwapCardEvent(this.card);
}

class SwapEventLandmarkProjectEvent extends KingdomBlocEvent {
  final DominionCard card;

  SwapEventLandmarkProjectEvent(this.card);
}

class UndoSwapEvent extends KingdomBlocEvent {}
