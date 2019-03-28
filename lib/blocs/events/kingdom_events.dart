import 'package:dominionizer_app/blocs/enums/kingdom_enums.dart';
import 'package:meta/meta.dart';

abstract class KingdomBlocEvent {}

class RestoreMostRecentKingdomEvent extends KingdomBlocEvent {}

class DrawKingdomEvent extends KingdomBlocEvent {
  final bool autoBlacklist;
  final int shuffleSize;
  final List<int> setIds;

  DrawKingdomEvent(
      {@required this.autoBlacklist, @required this.shuffleSize, this.setIds});
}

class SortKingdomEvent extends KingdomBlocEvent {
  final KingdomSortType sortType;

  SortKingdomEvent(this.sortType);
}
