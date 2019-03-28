import 'dart:convert';
import 'dart:core';
import 'package:dominionizer_app/blocs/states/kingdom_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    if (_prefs != null) return _prefs;

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

  Future<void> saveMostRecentKingdom(KingdomState state) async =>
      await _setString(LATEST_KINGDOM, state.toJson());  

  Future<KingdomState> getMostRecentKingdom() async {
    var str = await _getString(LATEST_KINGDOM);
    var decoded = jsonDecode(str ?? "{}");
    return KingdomState.fromJson(decoded);
  }

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
  Future<void> setUseDarkTheme(bool useDark) async =>
      await _setBool(USE_DARK_THEME, useDark);
  Future<void> setAutoBlacklist(bool autoBlacklist) async =>
      await _setBool(AUTO_BLACKLIST, autoBlacklist);
  Future<void> setShuffleSize(int shuffleSize) async =>
      await _setInt(SHUFFLE_SIZE, shuffleSize);
}
