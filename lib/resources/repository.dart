import 'dart:async';
import 'package:dominionizer_app/blocs/states/kingdom_state.dart';

import 'database.dart';
import 'sharedpreferences.dart';

import '../model/dominion_set.dart';
import '../model/dominion_card.dart';

class Repository {
  final databaseProvider = DBProvider.db;
  final prefs = SharedPreferencesProvider.spp;

  Future<List<DominionSet>> fetchAllSets() => databaseProvider.getSets();
  Future<List<DominionSet>> fetchIncludedSets() => databaseProvider.getSets(true);
  Future updateSetInclusion(int id, bool included) =>
      databaseProvider.updateSetInclusion(id, included);
  Future updateAllSetsInclusion(bool included) =>
      databaseProvider.updateAllSetsInclusion(included);
  Future<List<DominionCard>> drawKingdomCards(List<int> sets, int limit) =>
      databaseProvider.drawKingdomCards(sets, limit);
  Future<DominionCard> swapKingdomCard(List<int> cardIds, List<int> sets) =>
      databaseProvider.getReplacementKingdomCard(cardIds, sets);
  Future<DominionCard> swapEventLandmarkProjectCard(List<int> cardIds, bool events, bool landmarks, bool projects) =>
      databaseProvider.getReplacementEventLandmarkProjectCard(cardIds, events, landmarks, projects);
  Future<List<DominionCard>> getCompositeCards(int cardId) =>
      databaseProvider.getCompositeCards(cardId);
  Future<List<DominionCard>> getBroughtCards(List<int> cardIds) =>
      databaseProvider.getBroughtCards(cardIds);
  Future<List<DominionCard>> getEventsLandmarksAndProjects(
          int limit, bool events, bool landmarks, bool projects) =>
      databaseProvider.getEventsLandmarksAndProjects(
          limit, events, landmarks, projects);

  Future resetBlacklist() async => await databaseProvider.clearBlacklist();
  Future blacklistCards(List<int> cardIds) async =>
      await databaseProvider.blacklistCards(cardIds);
  Future<void> removeCardFromBlacklist(int cardId) async =>
      await databaseProvider.unblacklistCards([cardId]);
  Future<List<DominionCard>> getBlacklistCards() async =>
      await databaseProvider.getBlacklistCards();

  Future<List<int>> getBlacklistIds() async => await prefs.getBlacklistIds();
  // Future<void> setBlacklistIds(List<int> ids) async => await prefs.setBlacklistIds(ids);

  Future<void> saveMostRecentKingdom(KingdomState state) async =>
      await prefs.saveMostRecentKingdom(state);
  Future<KingdomState> loadMostRecentKingdom() async =>
      await prefs.getMostRecentKingdom();

  Future<bool> getUseDarkTheme() async => await prefs.getUseDarkTheme() ?? false;
  Future<void> setUseDarkTheme(useDark) async =>
      await prefs.setUseDarkTheme(useDark);

  Future<bool> getAutoBlacklist() async => await prefs.getAutoBlacklist() ?? false;
  Future<void> setAutoBlacklist(autoBlacklist) async =>
      await prefs.setAutoBlacklist(autoBlacklist);

  Future<int> getShuffleSize() async => await prefs.getShuffleSize() ?? 10;
  Future<void> setShuffleSize(shuffleSize) async =>
      await prefs.setShuffleSize(shuffleSize);
}
