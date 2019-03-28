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
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path =
        join(documentsDirectory.path, "dominionizer-includes-blacklist.db");

    if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound) {
      ByteData data = await rootBundle.load(join('assets', 'dominionizer.db'));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

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
    var res = await db.update('sets', {'included': (selected ? 1 : 0)},
        where: 'id = ?', whereArgs: [id]);

    if (res >= 0) {
      return true;
    }

    return false;
  }

  Future<bool> updateAllSetsInclusion(bool included) async {
    final db = await database;
    var res = await db.update('sets', {'included': (included ? 1 : 0)});

    if (res >= 0)
      return true;
    else
      return false;
  }

  Future<List<DominionCard>> _getCards(
      List<String> whereClauses, String orderBy, int limit) async {
    final db = await database;

    StringBuffer sb = StringBuffer();
    sb.write(" SELECT c.*, ");
    sb.write(
        " (select group_concat(name) from sets s inner join cardsets cs on cs.set_id = s.id where cs.card_id = c.id) as set_names, ");
    sb.write(
        " (select group_concat(name) from types t inner join cardtypes ct on ct.type_id = t.id where ct.card_id = c.id) as type_names ");
    sb.write(" FROM cards c ");

    if (whereClauses != null && whereClauses.length > 0) {
      sb.write(" WHERE ${whereClauses.join(" AND ")} ");
    }

    if (orderBy != null) {
      sb.write(" ORDER BY $orderBy ");
    }

    if (limit != null && limit > 0) {
      sb.write(" LIMIT $limit ");
    }

    var res = await db.rawQuery(sb.toString());

    if (res.isNotEmpty) {
      List<DominionCard> cards =
          res.map((c) => DominionCard.fromMap(c)).toList();
      return cards;
    } else {
      return List<DominionCard>();
    }
  }

  Future<List<DominionCard>> drawKingdomCards(
      List<int> setsToInclude, int numberOfCards) async {
    List<String> whereClauses = [];

    whereClauses.add(" c.in_supply = 1 ");
    whereClauses.add(" c.blacklisted = 0 ");

    if (setsToInclude != null && setsToInclude.length > 0) {
      whereClauses.add(
          " c.id IN (SELECT cards.id FROM sets INNER JOIN cardsets ON sets.id = cardsets.set_id INNER JOIN cards ON cards.id = cardsets.card_id WHERE sets.id IN (${setsToInclude.join(",")})) ");
    }

    return await _getCards(whereClauses, "RANDOM()", numberOfCards);
  }

  Future<DominionCard> getReplacementKingdomCard(
      List<int> cardIds, List<int> setsToInclude) async {
    List<String> whereClauses = [];

    whereClauses.add(" c.in_supply = 1 ");
    whereClauses.add(" c.blacklisted = 0 ");
    whereClauses.add(" c.id NOT IN (${cardIds.join(",")}) ");

    if (setsToInclude != null && setsToInclude.length > 0) {
      whereClauses.add(
          " c.id IN (SELECT cards.id FROM sets INNER JOIN cardsets ON sets.id = cardsets.set_id INNER JOIN cards ON cards.id = cardsets.card_id WHERE sets.id IN (${setsToInclude.join(",")})) ");
    }

    var cards = await _getCards(whereClauses, "RANDOM()", 1);
    return cards.first;
  }

  Future<List<DominionCard>> getBlacklistCards() async {
    return await _getCards([" c.blacklisted = 1 "], "c.name", null);
  }

  Future<List<DominionCard>> getBroughtCards(List<int> cardIds) async {
    final db = await database;

    StringBuffer sb = StringBuffer();
    sb.write(" SELECT c.*, ");
    sb.write(
        " (select group_concat(name) from sets s inner join cardsets cs on cs.set_id = s.id where cs.card_id = c.id) as set_names, ");
    sb.write(
        " (select group_concat(name) from types t inner join cardtypes ct on ct.type_id = t.id where ct.card_id = c.id) as type_names ");
    sb.write(" FROM broughtcards bc ");
    sb.write(" INNER JOIN cards c ON c.id = bc.brought_id ");
    sb.write(
        " WHERE bc.bringer_id IN (${cardIds.map((cid) => "?").join(",")}) ");
    sb.write(" ORDER BY c.id ");

    var res = await db.rawQuery(sb.toString(), cardIds);

    if (res.isNotEmpty) {
      return res.map((c) => DominionCard.fromMap(c)).toList();
    } else {
      return List<DominionCard>();
    }
  }

  Future<List<DominionCard>> getCompositeCards(int cardId) async {
    final db = await database;

    StringBuffer sb = StringBuffer();
    sb.write(" SELECT c.*, ");
    sb.write(
        " (select group_concat(name) from sets s inner join cardsets cs on cs.set_id = s.id where cs.card_id = c.id) as set_names, ");
    sb.write(
        " (select group_concat(name) from types t inner join cardtypes ct on ct.type_id = t.id where ct.card_id = c.id) as type_names ");
    sb.write(" FROM pilecompositions pc ");
    sb.write(" INNER JOIN cards c ON c.id = pc.card_id ");
    sb.write(" WHERE pc.pile_id = ?; ");

    var res = await db.rawQuery(sb.toString(), [cardId]);

    if (res.isNotEmpty) {
      List<DominionCard> cards =
          res.map((c) => DominionCard.fromMap(c)).toList();
      return cards;
    } else {
      return List<DominionCard>();
    }
  }

  Future<List<DominionCard>> getEventsLandmarksAndProjects(
      int limit, bool events, bool landmarks, bool projects) async {
    final db = await database;

    List<String> types = [];
    if (events ?? false) {
      types.add("Event");
    }

    if (landmarks ?? false) {
      types.add("Landmark");
    }

    if (projects ?? false) {
      types.add("Project");
    }

    if (types.length == 0 || limit == 0) {
      return List<DominionCard>();
    }

    StringBuffer sb = StringBuffer();
    sb.write(" SELECT c.*, ");
    sb.write(
        " (select group_concat(name) from sets s inner join cardsets cs on cs.set_id = s.id where cs.card_id = c.id) as set_names, ");
    sb.write(
        " (select group_concat(name) from types t inner join cardtypes ct on ct.type_id = t.id where ct.card_id = c.id) as type_names ");
    sb.write(" FROM cards c ");
    sb.write(" WHERE c.id IN ");
    sb.write("  (SELECT cards.id FROM types ");
    sb.write("    INNER JOIN cardtypes ON types.id = cardtypes.type_id ");
    sb.write("    INNER JOIN cards ON cards.id = cardtypes.card_id ");
    sb.write("    WHERE types.name IN (${types.map((t) => "?").join(",")})");
    sb.write("  )");
    sb.write(" ORDER BY RANDOM() ");
    sb.write(" LIMIT ? ");

    List<dynamic> params = List<dynamic>();
    params.addAll(types);
    params.add(limit);
    var res = await db.rawQuery(sb.toString(), params);

    if (res.isNotEmpty) {
      List<DominionCard> cards =
          res.map((c) => DominionCard.fromMap(c)).toList();
      return cards;
    } else {
      return List<DominionCard>();
    }
  }

  Future clearBlacklist() async {
    final db = await database;

    StringBuffer sb = StringBuffer();
    sb.write(" UPDATE cards ");
    sb.write(" SET blacklisted = 0 ");

    db.rawUpdate(sb.toString());
  }

  Future unblacklistCards(List<int> cardIds) async {
    final db = await database;

    StringBuffer sb = StringBuffer();
    sb.write(" UPDATE cards ");
    sb.write(" SET blacklisted = 0 ");
    sb.write(" WHERE id IN (${cardIds.map((c) => "?").join(",")})");

    await db.rawUpdate(sb.toString(), cardIds);
  }

  Future blacklistCards(List<int> cardIds) async {
    final db = await database;

    StringBuffer sb = StringBuffer();
    sb.write(" UPDATE cards ");
    sb.write(" SET blacklisted = 1 ");
    sb.write(" WHERE id IN (${cardIds.map((c) => "?").join(",")})");

    db.rawUpdate(sb.toString(), cardIds);
  }
}
