import 'package:dominionizer_app/resources/repository.dart';
import 'package:flutter/material.dart';

class AppSettingsModel extends ChangeNotifier {
  bool _autoBlacklist = false;
  int _eventsLandmarksProjectsIncluded = 2;
  int _shuffleSize = 10;

  final _repository = Repository();

  AppSettingsModel() {
    _repository.getAutoBlacklist().then((blacklist) {
      _autoBlacklist = blacklist;
    });

    _repository.getShuffleSize().then((shuffleSize) {
      _shuffleSize = shuffleSize;
    });

    _repository.getEventsLandmarksProjectsIncluded().then((eventsProjectsLandmarksIncluded) {
      _eventsLandmarksProjectsIncluded = eventsProjectsLandmarksIncluded;
    });
  }

  bool get autoBlacklist => _autoBlacklist;
  set autoBlacklist(bool autoBlacklist) {
    _autoBlacklist = autoBlacklist;
    notifyListeners();
    _repository.setAutoBlacklist(_autoBlacklist);
  }

  int get shuffleSize => _shuffleSize;
  set shuffleSize(int shuffleSize) {
    _shuffleSize = shuffleSize;
    notifyListeners();
    _repository.setShuffleSize(_shuffleSize);
  }

  int get eventsLandmarksProjectsIncluded => _eventsLandmarksProjectsIncluded;
  set eventsLandmarksProjectsIncluded(int eventsLandmarksProjectsIncluded) {
    _eventsLandmarksProjectsIncluded = eventsLandmarksProjectsIncluded;
    notifyListeners();
    _repository.setEventsLandmarksProjectsIncluded(_eventsLandmarksProjectsIncluded);
  }
}