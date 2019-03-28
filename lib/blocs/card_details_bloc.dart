import 'dart:async';

import 'package:dominionizer_app/blocs/events/card_details_events.dart';
import 'package:dominionizer_app/blocs/states/card_details_state.dart';
import 'package:dominionizer_app/model/dominion_card.dart';
import 'package:dominionizer_app/resources/repository.dart';

export 'package:dominionizer_app/blocs/events/card_details_events.dart';
export 'package:dominionizer_app/blocs/states/card_details_state.dart';

class CardDetailsBloc {
  CardDetailsBloc() {
    _cardDetailsEventController.stream.listen(_mapEventToState);
  }

  final _repository = Repository();
  final _cardDetailsStateController =
      StreamController<CardDetailsState>.broadcast();
  final _cardDetailsEventController = StreamController<CardDetailsEvent>();

  List<DominionCard> _constituentCards = [];
  List<DominionCard> _broughtCards = [];

  Stream<CardDetailsState> get cardDetailsStream =>
      _cardDetailsStateController.stream;
  Sink<CardDetailsEvent> get _sink => _cardDetailsEventController.sink;

  void loadConstituentCards(int cardId) {
    _sink.add(CompositeCardsEvent(cardId));
  }

  void loadBroughtCards(int cardId) {
    _sink.add(BroughtCardsEvent(cardId));
  }

  void _mapEventToState(CardDetailsEvent event) async {
    CardDetailsState newState;

    if (event is CompositeCardsEvent) {
      _constituentCards = await _repository.getCompositeCards(event.cardId);
      newState = CardDetailsState(_constituentCards, _broughtCards);
    } else if (event is BroughtCardsEvent) {
      _broughtCards = await _repository.getBroughtCards([event.cardId]);
      newState = CardDetailsState(_constituentCards, _broughtCards);
    }

    _cardDetailsStateController.sink.add(newState);
  }

  dispose() {
    _cardDetailsStateController.close();
    _cardDetailsEventController.close();
  }
}
