import 'package:dominionizer_app/model/dominion_set.dart';
import 'package:meta/meta.dart';

@immutable
class SetsBlocState {
  final List<DominionSet> sets;
  final bool isLoading;

  SetsBlocState(this.sets, this.isLoading);
}