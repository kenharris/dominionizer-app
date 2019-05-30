import 'package:dominionizer_app/resources/repository.dart';
import 'package:flutter/material.dart';

class ThemeModel extends ChangeNotifier {
  bool _isDarkTheme = false;
  final _repository = Repository();

  ThemeModel() {
    _repository.getUseDarkTheme().then((useDark) {
      _isDarkTheme = useDark;
      notifyListeners();
    });
  }

  bool get useDarkTheme => _isDarkTheme;

  set useDarkTheme(bool useDark) {
    _isDarkTheme = useDark;
    notifyListeners();
    _repository.setUseDarkTheme(useDark);
  }
}