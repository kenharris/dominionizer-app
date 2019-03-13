import '../resources/repository.dart';
import 'package:meta/meta.dart';
import 'dart:async';

abstract class AppBlocEvent { }
class InitializeAppEvent extends AppBlocEvent { }
class ChangeAllSettingsEvent extends AppBlocEvent {
  final bool darkTheme;
  final bool autoBlacklist;
  final int shuffleSize;

  ChangeAllSettingsEvent(this.shuffleSize, this.autoBlacklist, this.darkTheme);
}

@immutable
class AppBlocState {
  final bool isDarkTheme;
  final int cardsToShuffle;
  final bool autoBlacklist;

  AppBlocState(this.cardsToShuffle, this.autoBlacklist, this.isDarkTheme);

  bool equals(AppBlocState _state) => _state != null && 
    (_state.isDarkTheme == isDarkTheme && _state.autoBlacklist == autoBlacklist && _state.cardsToShuffle == cardsToShuffle);
}

class AppBloc {
  AppBloc()
  {
    _appEventController.stream.listen(_mapEventToState);
  }

  final _repository = Repository();
  final _appStateController = StreamController<AppBlocState>.broadcast();
  final _appEventController = StreamController<AppBlocEvent>();

  // AppBlocState _state = AppBlocState(10, true, false);
  AppBlocState _state;

  AppBlocState get state => _state ?? AppBlocState(10, false, false);
  Stream<AppBlocState> get appStateStream => _appStateController.stream;

  Sink<AppBlocEvent> get _sink => _appEventController.sink;

  void initialize() {
    _sink.add(InitializeAppEvent());
  }

  void updateAllSettings(int shuffleSize, bool isAutoBlacklist, bool isDarkTheme) {
    _sink.add(new ChangeAllSettingsEvent(shuffleSize, isAutoBlacklist, isDarkTheme));
  }

  void _mapEventToState(AppBlocEvent event) async {
    if (event is InitializeAppEvent) {
      if (_state == null) {
        var useDark = await _repository.getUseDarkTheme() ?? false;
        var autoBlacklist = await _repository.getAutoBlacklist() ?? false;
        var shuffleSize = await _repository.getShuffleSize() ?? 10;

        _state = AppBlocState(shuffleSize, autoBlacklist, useDark);
      }
    } else if (event is ChangeAllSettingsEvent) {
      bool isDarkTheme = event.darkTheme;
      bool isAutoBlacklist = event.autoBlacklist;
      int shuffleSize = event.shuffleSize;

      _repository.setUseDarkTheme(isDarkTheme);
      _repository.setAutoBlacklist(isAutoBlacklist);
      _repository.setShuffleSize(shuffleSize);

      _state = AppBlocState(shuffleSize, isAutoBlacklist, isDarkTheme);
    }

    _appStateController.sink.add(_state);
  }

  dispose() {
    _appStateController.close();
    _appEventController.close();
  }
}