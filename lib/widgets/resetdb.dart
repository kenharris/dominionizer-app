import 'package:flutter/material.dart';
import 'package:dominionizer_app/widgets/serviceprovider.dart';
import 'package:dominionizer_app/blocs/sets_event.dart';

class ResetDatabaseButtonState extends State<ResetDatabaseButton> {  
  bool _resetting = false;

  void _resetDb() async
  {
    if (!_resetting) {
      setState(() {
        _resetting = true;
      });
      ServiceProviderWidget.of(context).setsBloc.setsEventSink.add(new ResetSetsEvent());
      setState(() {
        _resetting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: !_resetting ? _resetDb : null,
      child: Text("Refresh DB"),
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