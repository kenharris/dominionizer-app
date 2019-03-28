import 'package:meta/meta.dart';

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