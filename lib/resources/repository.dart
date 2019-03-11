import 'dart:async';
import 'database.dart';
import 'sharedpreferences.dart';

import '../model/setinfo.dart';
import '../model/card.dart';

class Repository {
  final databaseProvider = DBProvider.db;
  final prefs = SharedPreferencesProvider.spp;

  Future<List<SetInfo>> fetchAllSets() => databaseProvider.getSets();
  Future updateSetInclusion(SetName id, bool included) => databaseProvider.updateSetInclusion(id, included);
  Future updateAllSetsInclusion(bool included) => databaseProvider.updateAllSetsInclusion(included);
  Future<List<Card>> fetchCards({List<int> sets, int limit, bool shuffle}) => databaseProvider.getCards(sets: sets, limit: limit, sortByRandom: shuffle);

  Future<bool> getUseDarkTheme() async => await prefs.getUseDarkTheme();
  Future<void> setUseDarkTheme(useDark) async => await prefs.setUseDarkTheme(useDark);

  Future<bool> getAutoBlacklist() async => await prefs.getAutoBlacklist();
  Future<void> setAutoBlacklist(autoBlacklist) async => await prefs.setAutoBlacklist(autoBlacklist);

  Future<int> getShuffleSize() async => await prefs.getShuffleSize();
  Future<void> setShuffleSize(shuffleSize) async => await prefs.setShuffleSize(shuffleSize);
}