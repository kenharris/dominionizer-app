import 'package:dominionizer_app/blocs/theme_bloc.dart';
import 'package:dominionizer_app/widgets/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:dominionizer_app/dominion.dart';

void main() {
  final ThemeBloc themeService = ThemeBloc();

  runApp(DominionizerApp(themeService));
}

class DominionizerApp extends StatelessWidget {
  final ThemeBloc themeService;

  DominionizerApp(this.themeService);

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(themeBloc: themeService, child: RandomizerWidget());
  }
}
