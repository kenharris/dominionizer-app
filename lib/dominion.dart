import 'package:dominionizer_app/model/theme_model.dart';
import 'package:flutter/material.dart';

import 'package:dominionizer_app/pages.dart';
import 'package:dominionizer_app/themes/light.dart';
import 'package:dominionizer_app/themes/dark.dart';
import 'package:provider/provider.dart';

class RandomizerWidgetState extends State<RandomizerWidget> {
  @override
  Widget build (BuildContext ctxt) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: Provider.of<ThemeModel>(context).useDarkTheme ? DarkThemeData : LightThemeData,
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