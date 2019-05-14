import 'package:dominionizer_app/blocs/events/rules_events.dart';
import 'package:dominionizer_app/blocs/states/rules_state.dart';
import 'package:dominionizer_app/resources/repository.dart';

import 'dart:async';

export 'package:dominionizer_app/blocs/events/rules_events.dart';
export 'package:dominionizer_app/blocs/states/rules_state.dart';

class RulesBloc {
  RulesBloc()
  {
    _appEventController.stream.listen(_mapEventToState);
  }

  final _repository = Repository();
  final _appStateController = StreamController<RulesState>.broadcast();
  final _appEventController = StreamController<RulesEvent>();

  RulesState _state;

  RulesState get state => _state ?? RulesState([], []);
  Stream<RulesState> get stream => _appStateController.stream;

  Sink<RulesEvent> get _sink => _appEventController.sink;

  void initialize() {
    _sink.add(InitializeRulesEvent());
  }

  void updateRule(int categoryId, bool newValue) {
    _sink.add(new UpdateRulesCategoryEvent(categoryId, newValue));
  }

  void _mapEventToState(RulesEvent event) async {
    if (event is InitializeRulesEvent) {
      if (_state == null) {
        var categoryValues = await _repository.getCategoryValues();
        var cardCategories = await _repository.getCardCategories();

        _state = RulesState(cardCategories, categoryValues);
      }
    }
    else if (event is UpdateRulesCategoryEvent)
    {
      await _repository.setCategoryValue(event.categoryId, event.newValue);

      var categoryValues = await _repository.getCategoryValues();
      var cardCategories = await _repository.getCardCategories();

      _state = RulesState(cardCategories, categoryValues);
    }

    _appStateController.sink.add(_state);
  }

  dispose() {
    _appStateController.close();
    _appEventController.close();
  }
}