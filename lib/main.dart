import 'package:flutter/material.dart';

import 'package:dominionizer_app/dominion.dart';
import 'package:dominionizer_app/blocs/settings_bloc.dart';
import 'package:dominionizer_app/widgets/app_settings.dart';

void main() {
  final SettingsBloc appService = SettingsBloc();

  runApp(DominionizerApp(appService));
}

class DominionizerApp extends StatelessWidget {
  final SettingsBloc appService;

  DominionizerApp(this.appService);

  @override
  Widget build(BuildContext context) {
    return AppSettingsProvider(appBloc: appService, child: RandomizerWidget());
  }
}
