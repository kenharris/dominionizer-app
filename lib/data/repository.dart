import '../model/setinfo.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Repository {
  static final Repository _repo = new Repository._internal();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Repository._internal();

  static Repository get() {
    return _repo;
  }

  Future<List<SetInfo>> getSetInfos() {
    return _prefs.then((SharedPreferences prefs) {
      String strSets = prefs.getString('sets');
      if (strSets != null)
      {
        List<dynamic> d = jsonDecode(strSets);
        List<SetInfo> si = d.map((s) => SetInfo.fromJson(s)).toList();
        return si;

        // List<SetInfo> si = jsonDecode(strSets).map((s) => SetInfo.fromJson(s)).toList();
        // return si;
      }
      else
      {
        List<SetInfo> _freshSets = new List<SetInfo>();

        _freshSets.add(new SetInfo(id: 1, name: "Dominion", selected: false));
        _freshSets.add(new SetInfo(id: 2, name: "Dominion: 2nd Edition", selected: false));
        _freshSets.add(new SetInfo(id: 3, name: "Intrigue", selected: false));
        _freshSets.add(new SetInfo(id: 4, name: "Intrigue: 2nd Edition", selected: false));
        _freshSets.add(new SetInfo(id: 5, name: "Seaside", selected: false));
        _freshSets.add(new SetInfo(id: 6, name: "Alchemy", selected: false));
        _freshSets.add(new SetInfo(id: 7, name: "Prosperity", selected: false));
        _freshSets.add(new SetInfo(id: 8, name: "Cornucopia", selected: false));
        _freshSets.add(new SetInfo(id: 9, name: "Dark Ages", selected: false));
        _freshSets.add(new SetInfo(id: 10, name: "Guilds", selected: false));
        _freshSets.add(new SetInfo(id: 11, name: "Adventures", selected: false));
        _freshSets.add(new SetInfo(id: 12, name: "Empires", selected: false));
        _freshSets.add(new SetInfo(id: 13, name: "Nocturne", selected: false));
        _freshSets.add(new SetInfo(id: 14, name: "Renaissance", selected: false));

        return _freshSets;
      }
    });
  }

  Future<bool> updateSetInfos(List<SetInfo> sets) {
    return _prefs.then((SharedPreferences prefs) {
      return prefs.setString('sets', json.encode(sets));
    });
  }
}