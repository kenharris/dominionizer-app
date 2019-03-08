import '../model/card.dart';
import '../resources/repository.dart';
import 'package:meta/meta.dart';
import 'dart:async';

abstract class KingdomBlocEvent { }
class DrawKingdomEvent extends KingdomBlocEvent { }

@immutable
class KingdomBlocState {
  final bool isLoading;
  final List<Card> cards;

  KingdomBlocState(this.cards, this.isLoading);
}

class KingdomBloc {
  KingdomBloc()
  {
    _kingdomEventController.stream.listen(_mapEventToState);
    _kingdomEventController.sink.add(new DrawKingdomEvent());
  }

  final _repository = Repository();
  final _kingdomStateController = StreamController<KingdomBlocState>.broadcast();
  final _kingdomEventController = StreamController<KingdomBlocEvent>();

  KingdomBlocState _state = KingdomBlocState([], false);

  Sink<KingdomBlocEvent> get kingdomEventSink => _kingdomEventController.sink;
  Stream<KingdomBlocState> get kingdomStream => _kingdomStateController.stream;

  void _mapEventToState(KingdomBlocEvent event) async {
    KingdomBlocState newState;

    if (event is DrawKingdomEvent)
    {
      List<Card> cards = await _repository.fetchCards(limit: 10, shuffle: true);
      cards.sort((a,b) => a.name.compareTo(b.name));
      newState = KingdomBlocState(cards, false);
    }
    
    _state = KingdomBlocState(newState.cards, false);
    _kingdomStateController.sink.add(newState);
  }

  dispose() {
    _kingdomStateController.close();
    _kingdomEventController.close();
  }
}