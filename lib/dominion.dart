import 'package:dominionizer_app/blocs/states/theme_state.dart';
import 'package:dominionizer_app/widgets/theme_provider.dart';
import 'package:flutter/material.dart';

import 'package:dominionizer_app/pages.dart';
import 'package:dominionizer_app/themes/light.dart';
import 'package:dominionizer_app/themes/dark.dart';

class RandomizerWidgetState extends State<RandomizerWidget> {
  bool _isDarkTheme = false;

  void _reactToState(ThemeState state) {
    if (state != null && _isDarkTheme != state.isDarkTheme) {
      setState(() {
        _isDarkTheme = state.isDarkTheme ?? false;
      });
    }
  }

  @override
  Widget build (BuildContext ctxt) {
    ThemeProvider.of(context).appStateStream.listen(_reactToState);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: _isDarkTheme ? DarkThemeData : LightThemeData,
      home: new Scaffold(
        body: KingdomPage(title: 'Randomize Kingdom'),
      ),
    );
  }
}

class RandomizerWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RandomizerWidgetState();
}