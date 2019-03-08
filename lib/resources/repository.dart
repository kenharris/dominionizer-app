import 'dart:async';
import 'database.dart';
import '../model/setinfo.dart';
import '../model/card.dart';

class Repository {
  final databaseProvider = DBProvider.db;

  Future<List<SetInfo>> fetchAllSets() => databaseProvider.getSets();
  Future updateSetInclusion(SetName id, bool included) => databaseProvider.updateSetInclusion(id, included);  
  Future<List<Card>> fetchCards({List<int> sets, int limit, bool shuffle}) => databaseProvider.getCards(limit: limit, sortByRandom: shuffle);
}