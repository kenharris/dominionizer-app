import 'package:flutter/material.dart';
import 'package:dominionizer_app/widgets/serviceprovider.dart';
import 'package:dominionizer_app/blocs/sets_event.dart';
import 'package:dominionizer_app/blocs/sets_bloc.dart';

class ResetDatabaseButtonState extends State<ResetDatabaseButton> {  
  bool _resetting = false;

  void _resetDb() async
  {
    if (!_resetting) {
      setState(() {
        _resetting = true;
      });
      ServiceProviderWidget.of(context).setsBloc.setsEventSink.add(new ResetSetsEvent());
    }
  }

  void _updateStatus(SetsBlocState state) {
      setState(() {
        _resetting = state.isLoading;
      });
  }

  @override
  Widget build(BuildContext context) {
    ServiceProviderWidget.of(context).setsBloc.sets.listen(_updateStatus);
    return FlatButton(
      onPressed: !_resetting ? _resetDb : null,
      child: (_resetting) ? CircularProgressIndicator() : Text("Refresh DB"),
      color: Colors.red,
      textColor: Colors.yellow,
    );
  }
}

class ResetDatabaseButton extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() => ResetDatabaseButtonState();
}