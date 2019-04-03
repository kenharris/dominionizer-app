import 'package:dominionizer_app/blocs/theme_bloc.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends InheritedWidget {
  final ThemeBloc bloc;

  ThemeProvider({Widget child, @required ThemeBloc themeBloc}) :  bloc = themeBloc, super(child:child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static ThemeBloc of(BuildContext context) =>
    (context.inheritFromWidgetOfExactType(ThemeProvider) as ThemeProvider).bloc;
}