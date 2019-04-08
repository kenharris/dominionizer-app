import 'package:flutter/material.dart';
import 'package:dominionizer_app/blocs/sets_bloc.dart';

class ServiceProviderWidget extends InheritedWidget {
  final SetsBloc setsBloc = SetsBloc();

  ServiceProviderWidget({Widget child}) : super(child:child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static SetsBloc of(BuildContext context) =>
    (context.inheritFromWidgetOfExactType(ServiceProviderWidget) as ServiceProviderWidget).setsBloc;
}