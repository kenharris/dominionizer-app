import 'package:flutter/material.dart';

import 'package:dominionizer_app/blocs/settings_bloc.dart';
import 'package:dominionizer_app/pages.dart';
import 'package:dominionizer_app/themes/light.dart';
import 'package:dominionizer_app/themes/purple.dart';
import 'package:dominionizer_app/widgets/app_settings.dart';

class RandomizerWidgetState extends State<RandomizerWidget> {
  bool _isDarkTheme = false;

  void _reactToState(SettingsState state) {
    if (state != null && _isDarkTheme != state.isDarkTheme) {
      setState(() {
        _isDarkTheme = state.isDarkTheme ?? false;
      });
    }
  }

  @override
  Widget build (BuildContext ctxt) {
    AppSettingsProvider.of(context).appStateStream.listen(_reactToState);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: _isDarkTheme ? PurpleThemeData : LightThemeData,
      home: new Scaffold(
        body: KingdomPage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class RandomizerWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RandomizerWidgetState();
}