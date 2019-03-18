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
  Future<List<DominionCard>> fetchCards({List<int> sets, int limit, bool shuffle, List<int> blacklistIds}) => databaseProvider.getCards(sets: sets, limit: limit, sortByRandom: shuffle, blacklistIds: blacklistIds);

  Future<List<DominionCard>> getBlacklistCards() async {
    var bids = await prefs.getBlacklistIds();
    var cards = await databaseProvider.getCards(idsToFetch: bids);

    return cards;
  }

  Future<void> removeCardFromBlacklist(int cardId) async {
    var bids = await prefs.getBlacklistIds();
    if (bids != null && bids.length > 0) {
      bids.remove(cardId);
    }
    await prefs.setBlacklistIds(bids);
  }

  Future<List<int>> getBlacklistIds() async => await prefs.getBlacklistIds();
  Future<void> setBlacklistIds(List<int> ids) async => await prefs.setBlacklistIds(ids);

  Future<void> saveMostRecentKingdom(List<DominionCard> cards) async => await prefs.saveMostRecentKingdom(cards);
  Future<List<DominionCard>> loadMostRecentKingdom() async => await prefs.getMostRecentKingdom();
  
  Future<bool> getUseDarkTheme() async => await prefs.getUseDarkTheme();
  Future<void> setUseDarkTheme(useDark) async => await prefs.setUseDarkTheme(useDark);

  Future<bool> getAutoBlacklist() async => await prefs.getAutoBlacklist();
  Future<void> setAutoBlacklist(autoBlacklist) async => await prefs.setAutoBlacklist(autoBlacklist);

  Future<int> getShuffleSize() async => await prefs.getShuffleSize();
  Future<void> setShuffleSize(shuffleSize) async => await prefs.setShuffleSize(shuffleSize);
}