import 'package:flutter/material.dart';

import 'package:dominionizer_app/blocs/settings_bloc.dart';

class AppSettingsProvider extends InheritedWidget {
  final SettingsBloc appBloc;

  AppSettingsProvider({
    Widget child,
    @required SettingsBloc appBloc
    }) :  appBloc = appBloc,
          super(child:child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static SettingsBloc of(BuildContext context) =>
    (context.inheritFromWidgetOfExactType(AppSettingsProvider) as AppSettingsProvider).appBloc;
}