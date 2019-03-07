import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';
import '../model/setinfo.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database _database;

  final List<Map<String, dynamic>> SETS = [
    {
      'id': SetName.Dominion.index,
      'name': 'Dominion',
      'release': 'Summer 2008',
      'number_of_cards': 500,
      'included': false
    },
    {
      'id': SetName.DominionSecondEdition.index,
      'name': 'Dominion (2nd Edition)',
      'release': 'Fall 2016',
      'number_of_cards': 500,
      'included': false
    },
    {
      'id': SetName.Intrigue.index,
      'name': 'Intrigue',
      'release': 'Spring 2009',
      'number_of_cards': 500,
      'included': false
    },
    {
      'id': SetName.IntrigueSecondEdition.index,
      'name': 'Intrigue (2nd Edition)',
      'release': 'Fall 2016',
      'number_of_cards': 300,
      'included': false
    },
    {
      'id': SetName.Seaside.index,
      'name': 'Seaside',
      'release': 'Fall 2009',
      'number_of_cards': 300,
      'included': false
    },
    {
      'id': SetName.Alchemy.index,
      'name': 'Alchemy',
      'release': 'Spring 2010',
      'number_of_cards': 150,
      'included': false
    },
    {
      'id': SetName.Prosperity.index,
      'name': 'Prosperity',
      'release': 'Fall 2010',
      'number_of_cards': 300,
      'included': false
    },
    {
      'id': SetName.Cornucopia.index,
      'name': 'Cornucopia',
      'release': 'Summer 2011',
      'number_of_cards': 150,
      'included': false
    },
    {
      'id': SetName.Hinterlands.index,
      'name': 'Hinterlands',
      'release': 'Fall 2011',
      'number_of_cards': 300,
      'included': false
    },
    {
      'id': SetName.DarkAges.index,
      'name': 'Dark Ages',
      'release': 'Fall 2012',
      'number_of_cards': 500,
      'included': false
    },
    {
      'id': SetName.Guilds.index,
      'name': 'Guilds',
      'release': 'Summer 2013',
      'number_of_cards': 150,
      'included': false
    },
    {
      'id': SetName.Adventures.index,
      'name': 'Adventures',
      'release': 'Spring 2015',
      'number_of_cards': 400,
      'included': false
    },
    {
      'id': SetName.Empires.index,
      'name': 'Empires',
      'release': 'Summer 2016',
      'number_of_cards': 300,
      'included': false
    },
    {
      'id': SetName.Nocturne.index,
      'name': 'Nocturne',
      'release': 'Fall 2017',
      'number_of_cards': 500,
      'included': false
    },
    {
      'id': SetName.Renaissance.index,
      'name': 'Renaissance',
      'release': 'Fall 2018',
      'number_of_cards': 300,
      'included': false
    }
  ];

  Future<Database> get database async {
    if (_database != null)
      return _database;

    _database = await initDB();
    return _database;
  }

  refreshDB() async {
    var db = await database;
    await db.delete('sets');

    for (final record in SETS) {
      await db.insert("sets", record);
    }
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "Dominion.db");
    return await openDatabase(path, version: 1, readOnly: false, onOpen: (db) {
    }, onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE sets ("
          "id INTEGER PRIMARY KEY,"
          "name TEXT,"
          "release TEXT,"
          "number_of_cards INTEGER,"
          "included BIT"
          ")");
    });
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
}