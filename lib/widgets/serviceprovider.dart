import 'package:flutter/material.dart';
import '../blocs/sets_bloc.dart';

class ServiceProviderWidget extends InheritedWidget {
  final SetsBloc setsBloc = SetsBloc();

  ServiceProviderWidget({Widget child}) : super(child:child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static ServiceProviderWidget of(BuildContext context) =>
    context.inheritFromWidgetOfExactType(ServiceProviderWidget);
}