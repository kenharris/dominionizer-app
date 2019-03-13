import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'dart:typed_data';
import '../model/setinfo.dart';
import '../model/card.dart';
import 'package:flutter/services.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null)
      return _database;

    _database = await initDB();
    return _database;
  }
  
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "dominion.db");

    // Only copy if the database doesn't exist
    if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound){
      // Load database from asset and copy
      ByteData data = await rootBundle.load(join('assets', 'dominion.db'));
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Save copied asset to documents
      await new File(path).writeAsBytes(bytes);
    }

    return await openDatabase(path, version: 1, readOnly: false);
  }

  Future<List<SetInfo>> getSets() async {
    final db = await database;
    var res = await db.query('sets');
    if (res.isNotEmpty) {
      List<SetInfo> sets = res.map((s) => SetInfo.fromMap(s)).toList();
      return sets;
    } else {
      return new List<SetInfo>();
    }
  }

  Future<bool> updateSetInclusion(SetName id, bool selected) async {
    final db = await database;
    var res = await db.update('sets', { 'included': (selected ? 1 : 0) }, where: 'id = ?', whereArgs: [id.index]);

    if (res >= 0) {
      return true;
    }

    return false;
  }

  Future<bool> updateAllSetsInclusion(bool included) async {
    final db = await database;
    var res = await db.update('sets', { 'included': (included ? 1 : 0) });

    if (res >= 0)
      return true;
    else
      return false;
  }

  Future<List<Card>> getCards({List<int> sets, int limit, bool sortByRandom, List<int> blacklistIds, List<int> idsToFetch}) async {
    final db = await database;
    
    StringBuffer sb = StringBuffer();
    sb.write(" SELECT * FROM cards ");

    List<String> whereClauses = [];
    if (sets != null && sets.length > 0) {
      whereClauses.add(" [set] in (${sets.map((s) => s.toString()).join(",")}) ");
    }

    if (blacklistIds != null && blacklistIds.length > 0) {
      whereClauses.add(" [id] NOT IN (${blacklistIds.join(",")}) ");
    }

    if (idsToFetch != null) {
      if (idsToFetch.length > 0) {
        whereClauses.add(" [id] IN (${idsToFetch.join(",")}) ");
      } else {
        whereClauses.add(" [id] = -1 ");
      }
    }
    
    if (whereClauses.length > 0) {
      sb.write(" WHERE ${whereClauses.join(" AND ")} ");
    }

    if (sortByRandom != null)
      sb.write(" ORDER BY RANDOM() ");
    if (limit != null)
      sb.write(" LIMIT $limit ");
    
    var res = await db.rawQuery(sb.toString());

    if (res.isNotEmpty) {
      List<Card> cards = res.map((c) => Card.fromMap(c)).toList();
      return cards;
    } else {
      return List<Card>();
    }
  }
}