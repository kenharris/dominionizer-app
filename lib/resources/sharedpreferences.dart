import 'dart:convert';
import 'dart:core';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dominionizer_app/model/card.dart';

class SharedPreferencesProvider {
  static const String BLACKLIST = 'Blacklist';
  static const String USE_DARK_THEME = 'UseDarkTheme';
  static const String AUTO_BLACKLIST = 'AutoBlacklist';
  static const String SHUFFLE_SIZE = 'ShuffleSize';
  static const String LATEST_KINGDOM = 'LatestKingdom';

  SharedPreferencesProvider._();
  static final SharedPreferencesProvider spp = SharedPreferencesProvider._();

  static SharedPreferences _prefs;

  Future<SharedPreferences> get prefs async {
    if (_prefs != null)
      return _prefs;

    _prefs = await SharedPreferences.getInstance();
    return _prefs;
  }

  Future<void> _remove(String key) async {
    final p = await prefs;
    return p.remove(key);
  }

  Future<bool> _getBool(String key) async {
    final p = await prefs;
    return p.getBool(key);
  }

  Future<void> _setBool(String key, bool val) async {
    final p = await prefs;
    return p.setBool(key, val);
  }

  Future<int> _getInt(String key) async {
    final p = await prefs;
    return p.getInt(key);
  }

  Future<void> _setInt(String key, int val) async {
    final p = await prefs;
    return p.setInt(key, val);
  }

  Future<String> _getString(String key) async {
    final p = await prefs;
    return p.getString(key);
  }

  Future<void> _setString(String key, String val) async {
    final p = await prefs;
    return p.setString(key, val);
  }

  Future<List<String>> _getStringList(String key) async {
    final p = await prefs;
    return p.getStringList(key);
  }

  Future<void> _setStringList(String key, List<String> value) async {
    final p = await prefs;
    return p.setStringList(key, value);
  }

  Future<void> saveMostRecentKingdom(List<DominionCard> cards) async => 
    await _setStringList(LATEST_KINGDOM, cards.map((c) => c.toJson()).toList());

  Future<List<DominionCard>> getMostRecentKingdom() async =>
    (await _getStringList(LATEST_KINGDOM))?.map((s) => DominionCard.fromMap(jsonDecode(s)))?.toList() ?? [];

  Future<List<int>> getBlacklistIds() async {
    var str = await _getString(BLACKLIST);
    if (str != null && str.isNotEmpty) {
      return str.split('|')?.map(int.parse)?.toList() ?? [];
    }

    return [];
  }

  Future<void> setBlacklistIds(List<int> ids) async {
    if (ids == null || ids.length == 0) {
      await _remove(BLACKLIST);
    }
    await _setString(BLACKLIST, ids.join("|"));
  }

  Future<bool> getUseDarkTheme() async => await _getBool(USE_DARK_THEME);
  Future<bool> getAutoBlacklist() async => await _getBool(AUTO_BLACKLIST);
  Future<int> getShuffleSize() async => await _getInt(SHUFFLE_SIZE);
  Future<void> setUseDarkTheme(bool useDark) async => await _setBool(USE_DARK_THEME, useDark);
  Future<void> setAutoBlacklist(bool autoBlacklist) async => await _setBool(AUTO_BLACKLIST, autoBlacklist);
  Future<void> setShuffleSize(int shuffleSize) async => await _setInt(SHUFFLE_SIZE, shuffleSize);
}