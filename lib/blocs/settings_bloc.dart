import 'package:dominionizer_app/blocs/events/settings_events.dart';
import 'package:dominionizer_app/blocs/states/settings_state.dart';
import 'package:dominionizer_app/resources/repository.dart';

import 'dart:async';

export 'package:dominionizer_app/blocs/events/settings_events.dart';
export 'package:dominionizer_app/blocs/states/settings_state.dart';

class SettingsBloc {
  SettingsBloc()
  {
    _appEventController.stream.listen(_mapEventToState);
  }

  final _repository = Repository();
  final _appStateController = StreamController<SettingsState>.broadcast();
  final _appEventController = StreamController<SettingsEvent>();

  SettingsState _state;

  SettingsState get state => _state ?? SettingsState(10, false, false, 2);
  Stream<SettingsState> get appStateStream => _appStateController.stream;

  Sink<SettingsEvent> get _sink => _appEventController.sink;

  void initialize() {
    _sink.add(InitializeAppEvent());
  }

  void updateAllSettings(int shuffleSize, bool isAutoBlacklist, bool isDarkTheme, int eventsLandmarksProjectsIncluded) {
    _sink.add(new ChangeAllSettingsEvent(shuffleSize, isAutoBlacklist, isDarkTheme, eventsLandmarksProjectsIncluded));
  }

  void _mapEventToState(SettingsEvent event) async {
    if (event is InitializeAppEvent) {
      if (_state == null) {
        var useDark = await _repository.getUseDarkTheme();
        var autoBlacklist = await _repository.getAutoBlacklist();
        var shuffleSize = await _repository.getShuffleSize();
        var eventsLandmarksProjectsIncluded = await _repository.getEventsLandmarksProjectsIncluded();

        _state = SettingsState(shuffleSize, autoBlacklist, useDark, eventsLandmarksProjectsIncluded);
      }
    } else if (event is ChangeAllSettingsEvent) {
      bool isDarkTheme = event.darkTheme;
      bool isAutoBlacklist = event.autoBlacklist;
      int shuffleSize = event.shuffleSize;
      int eventsLandmarksProjectsIncluded = event.eventsLandmarksProjectsIncluded;

      _repository.setUseDarkTheme(isDarkTheme);
      _repository.setAutoBlacklist(isAutoBlacklist);
      _repository.setShuffleSize(shuffleSize);
      _repository.setEventsLandmarksProjectsIncluded(eventsLandmarksProjectsIncluded);

      _state = SettingsState(shuffleSize, isAutoBlacklist, isDarkTheme, eventsLandmarksProjectsIncluded);
    }

    _appStateController.sink.add(_state);
  }

  dispose() {
    _appStateController.close();
    _appEventController.close();
  }
}