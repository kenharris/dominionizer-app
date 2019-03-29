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

  SettingsState get state => _state ?? SettingsState(10, false, false);
  Stream<SettingsState> get appStateStream => _appStateController.stream;

  Sink<SettingsEvent> get _sink => _appEventController.sink;

  void initialize() {
    _sink.add(InitializeAppEvent());
  }

  void updateAllSettings(int shuffleSize, bool isAutoBlacklist, bool isDarkTheme) {
    _sink.add(new ChangeAllSettingsEvent(shuffleSize, isAutoBlacklist, isDarkTheme));
  }

  void _mapEventToState(SettingsEvent event) async {
    if (event is InitializeAppEvent) {
      if (_state == null) {
        var useDark = await _repository.getUseDarkTheme();
        var autoBlacklist = await _repository.getAutoBlacklist();
        var shuffleSize = await _repository.getShuffleSize();

        _state = SettingsState(shuffleSize, autoBlacklist, useDark);
      }
    } else if (event is ChangeAllSettingsEvent) {
      bool isDarkTheme = event.darkTheme;
      bool isAutoBlacklist = event.autoBlacklist;
      int shuffleSize = event.shuffleSize;

      _repository.setUseDarkTheme(isDarkTheme);
      _repository.setAutoBlacklist(isAutoBlacklist);
      _repository.setShuffleSize(shuffleSize);

      _state = SettingsState(shuffleSize, isAutoBlacklist, isDarkTheme);
    }

    _appStateController.sink.add(_state);
  }

  dispose() {
    _appStateController.close();
    _appEventController.close();
  }
}