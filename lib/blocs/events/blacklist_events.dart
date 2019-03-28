import 'package:dominionizer_app/blocs/enums/blacklist_enums.dart';

abstract class BlacklistEvent {}

class LoadBlacklistEvent extends BlacklistEvent {}

class BlacklistCardEvent extends BlacklistEvent {
  final int cardId;

  BlacklistCardEvent(this.cardId);
}

class UnblacklistCardEvent extends BlacklistEvent {
  final int cardId;

  UnblacklistCardEvent(this.cardId);
}

class EmptyBlacklistEvent extends BlacklistEvent {}

class SortBlacklistEvent extends BlacklistEvent {
  final BlacklistSortType sortType;

  SortBlacklistEvent(this.sortType);
}
