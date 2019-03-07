import '../model/setinfo.dart';
import '../resources/repository.dart';
import 'dart:async';
import 'package:dominionizer_app/model/setinfo.dart';
import 'package:dominionizer_app/blocs/sets_event.dart';

class SetsBloc {
  List<SetInfo> _sets;

  SetsBloc()
  {
    _setsEventController.stream.listen(_mapEventToState);
    _setsEventController.sink.add(new SetsInitializeEvent());
  }

  final _repository = Repository();
  final _setsStateController = StreamController<List<SetInfo>>();
  final _setsEventController = StreamController<SetsEvent>();

  Sink<SetsEvent> get setsEventSink => _setsEventController.sink;

  get sets => _setsStateController.stream;

  void _mapEventToState(SetsEvent event) async {
    if (event is SetsInitializeEvent)
    {
      _sets = await _repository.fetchAllSets();
    }
    else if (event is SetInclusionEvent)
    {
      await _repository.updateSetInclusion(event.id, event.include);
      _sets = await _repository.fetchAllSets();
    }
    else if (event is ResetSetsEvent)
    {
      await _repository.refreshSets();
      _sets = await _repository.fetchAllSets();
    }

    _setsStateController.sink.add(_sets);
  }

  dispose() {
    _setsStateController.close();
    _setsEventController.close();
  }
}