import 'package:dominionizer_app/model/dominion_set.dart';

abstract class SetsEvent { }

class SetsInitializeEvent extends SetsEvent { }

class SetInclusionEvent extends SetsEvent {
  final int id;
  final bool include;

  SetInclusionEvent(this.id, this.include);
}

class SetIncludeAllEvent extends SetsEvent { }
class SetExcludeAllEvent extends SetsEvent { }