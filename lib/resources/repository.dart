import 'dart:async';
import 'package:dominionizer_app/blocs/states/kingdom_state.dart';
import 'package:dominionizer_app/blocs/states/rules_state.dart';

import 'database.dart';
import 'sharedpreferences.dart';

import 'package:dominionizer_app/model/dominion_set.dart';
import 'package:dominionizer_app/model/dominion_card.dart';

class Repository {
  final databaseProvider = DBProvider.db;
  final prefs = SharedPreferencesProvider.spp;

  Future<List<DominionSet>> fetchAllSets() => databaseProvider.getSets();
  Future<List<DominionSet>> fetchIncludedSets() => databaseProvider.getSets(true);
  Future updateSetInclusion(int id, bool included) =>
      databaseProvider.updateSetInclusion(id, included);
  Future updateAllSetsInclusion(bool included) =>
      databaseProvider.updateAllSetsInclusion(included);
  Future<List<DominionCard>> drawKingdomCards(List<int> sets, int limit) async =>
      await databaseProvider.drawKingdomCards(sets, limit);
  Future<DominionCard> swapKingdomCard(List<int> cardIds, List<int> sets) =>
      databaseProvider.getReplacementKingdomCard(cardIds, sets);
  Future<DominionCard> swapEventLandmarkProjectCard(List<int> cardIds, bool events, bool landmarks, bool projects) =>
      databaseProvider.getReplacementEventLandmarkProjectCard(cardIds, events, landmarks, projects);
  Future<List<DominionCard>> getCompositeCards(int cardId) =>
      databaseProvider.getCompositeCards(cardId);
  Future<List<DominionCard>> getBroughtCards(List<int> cardIds) =>
      databaseProvider.getBroughtCards(cardIds);
  Future<List<DominionCard>> getEventsLandmarksAndProjects(
          List<int> setIds, int limit, bool events, bool landmarks, bool projects) =>
      databaseProvider.getEventsLandmarksAndProjects(
          setIds, limit, events, landmarks, projects);

  Future<List<DominionCard>> drawCardsOfCategories(List<int> categoryIds, List<int> excludedCardIds) async =>
      await databaseProvider.drawCardsOfCategories(categoryIds, excludedCardIds);

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

  Future<int> getEventsLandmarksProjectsIncluded() async => await prefs.getEventsLandmarksProjectsIncluded() ?? 2;
  Future<void> setEventsLandmarksProjectsIncluded(int eventsProjectsLandmarksIncluded) async =>
      await prefs.setEventsLandmarksProjectsIncluded(eventsProjectsLandmarksIncluded);

  Future<List<CategoryValue>> getCategoryValues() async => await prefs.getCategoryValues();
  Future setCategoryValue(int categoryId, bool newValue) async => await prefs.setCategoryValue(categoryId, newValue);
  Future<List<CardCategory>> getCardCategories() async => await databaseProvider.getCardCategories();

  Future<List<DominionCard>> getCategoryCards(int categoryId) async => await databaseProvider.getCategoryCards(categoryId);
}
