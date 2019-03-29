import 'package:dominionizer_app/blocs/enums/kingdom_enums.dart';
import 'package:meta/meta.dart';

abstract class KingdomBlocEvent {}

class RestoreMostRecentKingdomEvent extends KingdomBlocEvent {}

class DrawKingdomEvent extends KingdomBlocEvent {}

class SortKingdomEvent extends KingdomBlocEvent {
  final KingdomSortType sortType;

  SortKingdomEvent(this.sortType);
}
