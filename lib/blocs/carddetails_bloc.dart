import '../model/dominion_card.dart';
import '../resources/repository.dart';
import 'package:meta/meta.dart';
import 'dart:async';

abstract class CardDetailsEvent { }
@immutable
class CompositeCardsEvent extends CardDetailsEvent {
  final int cardId;

  CompositeCardsEvent(this.cardId);
}
@immutable
class BroughtCardsEvent extends CardDetailsEvent {
  final int cardId;

  BroughtCardsEvent(this.cardId);
}

@immutable
class CardDetailsState {
  final List<DominionCard> constituentCards;
  final List<DominionCard> broughtCards;

  CardDetailsState(this.constituentCards, this.broughtCards);
}

class CardDetailsBloc {
  CardDetailsBloc()
  {
    _cardDetailsEventController.stream.listen(_mapEventToState);
  }

  final _repository = Repository();
  final _cardDetailsStateController = StreamController<CardDetailsState>.broadcast();  
  final _cardDetailsEventController = StreamController<CardDetailsEvent>();
  
  List<DominionCard> _constituentCards = [];
  List<DominionCard> _broughtCards = [];

  Stream<CardDetailsState> get cardDetailsStream => _cardDetailsStateController.stream;
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
    }
    else if (event is BroughtCardsEvent) {
      _broughtCards = await _repository.getBroughtCards(event.cardId);
      newState = CardDetailsState(_constituentCards, _broughtCards);
    }

    _cardDetailsStateController.sink.add(newState);
  }

  dispose() {
    _cardDetailsStateController.close();
    _cardDetailsEventController.close();
  }
}