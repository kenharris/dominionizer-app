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

  Future<List<Card>> getCards({int limit, bool sortByRandom}) async {
    final db = await database;
    var res = await db.query('cards', orderBy: sortByRandom ? "RANDOM()" : null, limit: (limit != null) ? limit : null);
    if (res.isNotEmpty) {
      List<Card> cards = res.map((c) => Card.fromMap(c)).toList();
      return cards;
    } else {
      return List<Card>();
    }
  }
}