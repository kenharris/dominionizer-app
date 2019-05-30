import 'package:dominionizer_app/model/appsettings_model.dart';
import 'package:dominionizer_app/model/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:dominionizer_app/dominion.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (context) => ThemeModel()),
        ChangeNotifierProvider(builder: (context) => AppSettingsModel())
      ],
      child: DominionizerApp()
    )
  );
}

class DominionizerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RandomizerWidget();
  }
}
