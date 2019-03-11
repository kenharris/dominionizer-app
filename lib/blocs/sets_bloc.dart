import '../model/setinfo.dart';
import '../resources/repository.dart';
import 'package:meta/meta.dart';
import 'dart:async';
import 'package:dominionizer_app/model/setinfo.dart';
import 'package:dominionizer_app/blocs/sets_event.dart';

@immutable
class SetsBlocState {
  final List<SetInfo> sets;
  final bool isLoading;

  SetsBlocState(this.sets, this.isLoading);
}

class SetsBloc {
  SetsBloc()
  {
    _setsEventController.stream.listen(_mapEventToState);
    _setsEventController.sink.add(new SetsInitializeEvent());
  }

  final _repository = Repository();
  final _setsStateController = StreamController<SetsBlocState>.broadcast();
  final _setsEventController = StreamController<SetsEvent>();

  SetsBlocState _state = SetsBlocState([], false);  

  Sink<SetsEvent> get setsEventSink => _setsEventController.sink;

  Stream<SetsBlocState> get sets => _setsStateController.stream;
  SetsBlocState get state => _state;

  void _mapEventToState(SetsEvent event) async {
    SetsBlocState newState;

    if (event is SetsInitializeEvent)
    {
      if (_state.sets == null || _state.sets.length == 0)
      {
        newState = SetsBlocState(await _repository.fetchAllSets(), _state.isLoading);
      }
      else
      {
        newState = _state;
      }
    }
    else if (event is SetInclusionEvent)
    {
      await _repository.updateSetInclusion(event.id, event.include);
      newState = SetsBlocState(await _repository.fetchAllSets(), _state.isLoading);
    }
    else if (event is SetIncludeAllEvent)
    {
      await _repository.updateAllSetsInclusion(true);
      newState = SetsBlocState(await _repository.fetchAllSets(), _state.isLoading);
    }
    else if (event is SetExcludeAllEvent)
    {
      await _repository.updateAllSetsInclusion(false);
      newState = SetsBlocState(await _repository.fetchAllSets(), _state.isLoading);
    }

    _state = SetsBlocState(newState.sets, newState.isLoading);
    _setsStateController.sink.add(newState);
  }

  dispose() {
    _setsStateController.close();
    _setsEventController.close();
  }
}