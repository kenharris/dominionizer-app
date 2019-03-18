import 'package:dominionizer_app/blocs/app_bloc.dart';
import 'package:dominionizer_app/pages.dart';
import 'package:dominionizer_app/themes/purple.dart';
import 'package:dominionizer_app/widgets/app_settings.dart';
import 'package:flutter/material.dart';

class RandomizerWidgetState extends State<RandomizerWidget> {
  bool _isDarkTheme = false;

  void _reactToState(AppBlocState state) {
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
      theme: PurpleThemeData,
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