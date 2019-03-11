import 'package:dominionizer_app/dominion.dart';
import 'package:dominionizer_app/widgets/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:dominionizer_app/blocs/app_bloc.dart';

void main() {
  final AppBloc appService = AppBloc();

  runApp(DominionizerApp(appService));
}

class DominionizerApp extends StatelessWidget {
  final AppBloc appService;

  DominionizerApp(this.appService);

  @override
  Widget build(BuildContext context) {
    return AppSettingsProvider (
      appBloc: appService,
      child: RandomizerWidget()
    );
  }
}