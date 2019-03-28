import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'dart:typed_data';
import '../model/dominion_set.dart';
import '../model/dominion_card.dart';
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
    String path = join(documentsDirectory.path, "dominionizer-NEW.db");

    if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound) {
      ByteData data = await rootBundle.load(join('assets', 'dominionizer.db'));
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await new File(path).writeAsBytes(bytes);
    }

    // return await openDatabase(path, version: 1, readOnly: false, onUpgrade: (db, oldVersion, newVersion) {
    //   // TODO: implement updgrade logic
    // });
    return await openDatabase(path, version: 1, readOnly: false);
  }

  Future<List<DominionSet>> getSets() async {
    final db = await database;
    var res = await db.query('sets');
    if (res.isNotEmpty) {
      List<DominionSet> sets = res.map((s) => DominionSet.fromMap(s)).toList();
      return sets;
    } else {
      return new List<DominionSet>();
    }
  }

  Future<bool> updateSetInclusion(int id, bool selected) async {
    final db = await database;
    var res = await db.update('sets', { 'included': (selected ? 1 : 0) }, where: 'id = ?', whereArgs: [id]);

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

  Future<List<DominionCard>> getCards({List<int> sets, int limit, bool sortByRandom, List<int> blacklistIds, List<int> idsToFetch}) async {
    final db = await database;
    
    StringBuffer sb = StringBuffer();
    sb.write(" SELECT c.*, s.name as set_name, (select group_concat(name) from types t inner join cardtypes ct on ct.type_id = t.id where ct.card_id = c.id) as type_names FROM cards c ");
    sb.write(" INNER JOIN cardsets cs ON cs.card_id = c.id ");
    sb.write(" INNER JOIN sets s on cs.set_id = s.id ");

    List<String> whereClauses = [];
    whereClauses.add(" c.in_supply = 1 ");
    if (blacklistIds != null && blacklistIds.length > 0) {
      whereClauses.add(" c.id NOT IN (${blacklistIds.join(",")}) ");
    }

    if (idsToFetch != null) {
      if (idsToFetch.length > 0) {
        whereClauses.add(" c.id IN (${idsToFetch.join(",")}) ");
      } else {
        whereClauses.add(" c.id = -1 ");
      }
    }

    if (sets != null && sets.length > 0) {      
      whereClauses.add(" s.id in (${sets.map((s) => s.toString()).join(",")}) ");
    }
    
    if (whereClauses.length > 0) {
      sb.write(" WHERE ${whereClauses.join(" AND ")} ");
    }

    sb.write(" ORDER BY c.id ASC, s.id ASC ");

    var res = await db.rawQuery(sb.toString());

    if (res.isNotEmpty) {
      List<DominionCard> cards = res.map((c) => DominionCard.fromMap(c)).toList();
      deduplicateCardList(cards);
      if (sortByRandom ?? false) {
        shuffleCardList(cards);
      }
      return cards.take(limit).toList();
    } else {
      return List<DominionCard>();
    }
  }

  Future<List<DominionCard>> getBroughtCards(List<int> cardIds) async {
    final db = await database;
    
    StringBuffer sb = StringBuffer();
    sb.write(" SELECT c.*, s.name as set_name, (select group_concat(name) from types t inner join cardtypes ct on ct.type_id = t.id where ct.card_id = c.id) as type_names FROM broughtcards bc ");
    sb.write(" INNER JOIN cards c ON c.id = bc.brought_id ");
    sb.write(" INNER JOIN cardsets cs on cs.card_id = c.id ");
    sb.write(" INNER JOIN sets s on cs.set_id = s.id ");
    // sb.write(" WHERE bc.bringer_id = $cardId ");
    sb.write(" WHERE bc.bringer_id IN (${cardIds.join(", ")}) ");
    sb.write(" ORDER BY c.id ");

    var res = await db.rawQuery(sb.toString());

    if (res.isNotEmpty) {
      List<DominionCard> cards = res.map((c) => DominionCard.fromMap(c)).toList();
      // deduplicateCardList(cards);
      return cards;
    } else {
      return List<DominionCard>();
    }
  }

  Future<List<DominionCard>> getCompositeCards(int cardId) async {
    final db = await database;
    
    StringBuffer sb = StringBuffer();
    sb.write(" SELECT * FROM cards c ");
    sb.write(" INNER JOIN pilecompositions pc ON c.id = pc.card_id ");
    sb.write(" WHERE pc.pile_id = $cardId; ");

    var res = await db.rawQuery(sb.toString());

    if (res.isNotEmpty) {
      List<DominionCard> cards = res.map((c) => DominionCard.fromMap(c)).toList();
      // deduplicateCardList(cards);
      return cards;
    } else {
      return List<DominionCard>();
    }
  }

  Future<List<DominionCard>> getEventsLandmarksAndProjects(int limit, bool events, bool landmarks, bool projects) async {
    final db = await database;

    List<String> types = [];
    if (events ?? false) {
      types.add("'Event'");
    }

    if (landmarks ?? false) {
      types.add("'Landmark'");
    }

    if (projects ?? false) {
      types.add("'Project'");
    }

    if (types.length == 0 || limit == 0) {
      return List<DominionCard>();
    }

    StringBuffer sb = StringBuffer();
    sb.write(" SELECT c.*, s.name as set_name, (select group_concat(name) from types t inner join cardtypes ct on ct.type_id = t.id where ct.card_id = c.id) as type_names FROM cards c ");
    sb.write(" INNER JOIN cardtypes ct ON c.id = ct.card_id ");
    sb.write(" INNER JOIN types t ON t.id = ct.type_id ");
    sb.write(" INNER JOIN cardsets cs on cs.card_id = c.id ");
    sb.write(" INNER JOIN sets s on s.id = cs.set_id ");
    sb.write(" WHERE t.name IN (${types.join(",")}) ");
    sb.write(" ORDER BY RANDOM() ");
    sb.write(" LIMIT $limit ");
    var res = await db.rawQuery(sb.toString());

    if (res.isNotEmpty) {
      List<DominionCard> cards = res.map((c) => DominionCard.fromMap(c)).toList();
      return cards;
    } else {
      return List<DominionCard>();
    }
  }
}