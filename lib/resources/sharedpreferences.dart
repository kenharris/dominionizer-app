import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesProvider {
  SharedPreferencesProvider._();
  static final SharedPreferencesProvider spp = SharedPreferencesProvider._();

  static SharedPreferences _prefs;

  Future<SharedPreferences> get prefs async {
    if (_prefs != null)
      return _prefs;

    _prefs = await SharedPreferences.getInstance();
    return _prefs;
  }
  
  // initDB() async {
  //   Directory documentsDirectory = await getApplicationDocumentsDirectory();
  //   String path = join(documentsDirectory.path, "dominion.db");

  //   // Only copy if the database doesn't exist
  //   if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound){
  //     // Load database from asset and copy
  //     ByteData data = await rootBundle.load(join('assets', 'dominion.db'));
  //     List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

  //     // Save copied asset to documents
  //     await new File(path).writeAsBytes(bytes);
  //   }

  //   return await openDatabase(path, version: 1, readOnly: false);
  // }

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

  Future<bool> getUseDarkTheme() async => await _getBool('UseDarkTheme');
  Future<bool> getAutoBlacklist() async => await _getBool('AutoBlacklist');
  Future<int> getShuffleSize() async => await _getInt('ShuffleSize');
  Future<void> setUseDarkTheme(bool useDark) async => await _setBool('UseDarkTheme', useDark);
  Future<void> setAutoBlacklist(bool autoBlacklist) async => await _setBool('AutoBlacklist', autoBlacklist);
  Future<void> setShuffleSize(int shuffleSize) async => await _setInt('ShuffleSize', shuffleSize);
}