import 'package:flutter/material.dart';
import 'package:dominionizer_app/blocs/app_bloc.dart';

class AppSettingsProvider extends InheritedWidget {
  final AppBloc appBloc;

  AppSettingsProvider({
    Widget child,
    @required AppBloc appBloc
    }) :  appBloc = appBloc,
          super(child:child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static AppBloc of(BuildContext context) =>
    (context.inheritFromWidgetOfExactType(AppSettingsProvider) as AppSettingsProvider).appBloc;
}