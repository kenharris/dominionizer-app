import '../resources/repository.dart';
import 'package:meta/meta.dart';
import 'dart:async';

abstract class AppBlocEvent { }
class InitializeAppEvent extends AppBlocEvent { }
class ChangeThemeEvent extends AppBlocEvent {
  final bool darkTheme;
  
  ChangeThemeEvent(this.darkTheme);
}
class ChangeAutoBlacklistEvent extends AppBlocEvent {
  final bool autoBlacklist;
  
  ChangeAutoBlacklistEvent(this.autoBlacklist);
}
class ChangeShuffleSizeEvent extends AppBlocEvent {
  final int shuffleSize;
  
  ChangeShuffleSizeEvent(this.shuffleSize);
}
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
    _appEventController.sink.add(InitializeAppEvent());
  }

  final _repository = Repository();
  final _appStateController = StreamController<AppBlocState>.broadcast();
  final _appEventController = StreamController<AppBlocEvent>();

  // AppBlocState _state = AppBlocState(10, true, false);
  AppBlocState _state;

  AppBlocState get state => _state ?? AppBlocState(10, false, false);

  Sink<AppBlocEvent> get appEventSink => _appEventController.sink;
  Stream<AppBlocState> get appStateStream => _appStateController.stream;

  void _mapEventToState(AppBlocEvent event) async {
    if (event is InitializeAppEvent) {
      if (_state == null) {
        var useDark = await _repository.getUseDarkTheme();
        var autoBlacklist = await _repository.getAutoBlacklist();
        var shuffleSize = await _repository.getShuffleSize();

        _state = AppBlocState(shuffleSize, autoBlacklist, useDark);
      }
    } else if (event is ChangeThemeEvent) {
      bool isDarkTheme = event.darkTheme;
      _repository.setUseDarkTheme(isDarkTheme);
      _state = AppBlocState(_state.cardsToShuffle, _state.autoBlacklist, isDarkTheme);
    } else if (event is ChangeAutoBlacklistEvent) {
      bool isAutoBlacklist = event.autoBlacklist;
      _repository.setAutoBlacklist(isAutoBlacklist);
      _state = AppBlocState(_state.cardsToShuffle, isAutoBlacklist, _state.isDarkTheme);
    } else if (event is ChangeShuffleSizeEvent) {
      int shuffleSize = event.shuffleSize;
      _repository.setShuffleSize(shuffleSize);
      _state = AppBlocState(shuffleSize, _state.autoBlacklist, _state.isDarkTheme);
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