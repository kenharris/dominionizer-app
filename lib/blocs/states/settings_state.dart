import 'package:meta/meta.dart';

@immutable
class SettingsState {
  final bool isDarkTheme;
  final int cardsToShuffle;
  final bool autoBlacklist;
  final int eventsLandmarksProjectsIncluded;

  SettingsState(this.cardsToShuffle, this.autoBlacklist, this.isDarkTheme, this.eventsLandmarksProjectsIncluded);

  bool equals(SettingsState _state) => _state != null && 
    (_state.isDarkTheme == isDarkTheme && 
      _state.autoBlacklist == autoBlacklist && 
      _state.cardsToShuffle == cardsToShuffle && 
      _state.eventsLandmarksProjectsIncluded == eventsLandmarksProjectsIncluded);
}