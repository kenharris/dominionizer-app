import 'dart:async';
import 'database.dart';
import '../model/setinfo.dart';

class Repository {
  final databaseProvider = DBProvider.db;

  Future<List<SetInfo>> fetchAllSets() => databaseProvider.getSets();
  Future updateSetInclusion(SetName id, bool included) => databaseProvider.updateSetInclusion(id, included);
  Future refreshSets() => databaseProvider.refreshDB();
}