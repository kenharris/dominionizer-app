import 'package:dominionizer_app/model/setinfo.dart';

abstract class SetsEvent { }

class SetsInitializeEvent extends SetsEvent { }

class SetInclusionEvent extends SetsEvent {
  final SetName id;
  final bool include;

  SetInclusionEvent(this.id, this.include);
}

class SetIncludeAllEvent extends SetsEvent { }
class SetExcludeAllEvent extends SetsEvent { }