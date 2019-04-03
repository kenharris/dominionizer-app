import 'package:meta/meta.dart';

@immutable
class ThemeState {
  final bool isDarkTheme;

  ThemeState(this.isDarkTheme);

  bool equals(ThemeState _state) => _state != null && (_state.isDarkTheme == isDarkTheme);
}