import 'package:meta/meta.dart';

@immutable
class SettingsState {
  final int cardsToShuffle;
  final bool autoBlacklist;
  final int eventsLandmarksProjectsIncluded;

  SettingsState(this.cardsToShuffle, this.autoBlacklist, this.eventsLandmarksProjectsIncluded);

  bool equals(SettingsState _state) => _state != null && 
    (_state.autoBlacklist == autoBlacklist && 
      _state.cardsToShuffle == cardsToShuffle && 
      _state.eventsLandmarksProjectsIncluded == eventsLandmarksProjectsIncluded);
}