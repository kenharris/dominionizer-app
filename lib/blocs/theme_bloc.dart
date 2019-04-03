import 'package:dominionizer_app/blocs/events/theme_events.dart';
import 'package:dominionizer_app/blocs/states/theme_state.dart';
import 'package:dominionizer_app/resources/repository.dart';

import 'dart:async';

export 'package:dominionizer_app/blocs/events/theme_events.dart';
export 'package:dominionizer_app/blocs/states/theme_state.dart';

class ThemeBloc {
  ThemeBloc()
  {
    _themeEventController.stream.listen(_mapEventToState);
    initialize();
  }

  final _repository = Repository();
  final _themeStateController = StreamController<ThemeState>.broadcast();
  final _themeEventController = StreamController<ThemeEvent>();

  ThemeState _state;

  ThemeState get state => _state ?? ThemeState(false);
  Stream<ThemeState> get appStateStream => _themeStateController.stream;

  Sink<ThemeEvent> get _sink => _themeEventController.sink;

  void initialize() {
    _sink.add(InitializeThemeEvent());
  }

  void changeTheme(bool isDarkTheme) {
    _sink.add(new ChangeThemeEvent(isDarkTheme));
  }

  void _mapEventToState(ThemeEvent event) async {
    if (event is InitializeThemeEvent) {
      var isDarkTheme = await _repository.getUseDarkTheme();

      _state = ThemeState(isDarkTheme);
    }
    else if (event is ChangeThemeEvent) {
      bool isDarkTheme = event.darkTheme;

      await _repository.setUseDarkTheme(isDarkTheme);

      _state = ThemeState(isDarkTheme);
    }

    _themeStateController.sink.add(_state);
  }

  dispose() {
    _themeStateController.close();
    _themeEventController.close();
  }
}