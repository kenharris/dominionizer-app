import 'package:dominionizer_app/blocs/kingdom_bloc.dart';
import 'package:flutter/material.dart';

class _KingdomSortDialogState extends State<KingdomSortDialog> {
  KingdomSortType _selectedValue;

  static const kingdomSortTypeNames = [
    "Card Name Ascending",
    "Card Name Descending",
    "Set Name Ascending",
    "Set Name Descending",
    "Cost Ascending",
    "Cost Descending"
  ];

  _KingdomSortDialogState(this._selectedValue);

  void _setRadioValue(KingdomSortType kst) {
    setState((){
      _selectedValue = kst;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 400,
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: KingdomSortType.values.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return RadioListTile(
                    title: Text("${kingdomSortTypeNames[index]}"),
                    selected: KingdomSortType.values[index] == _selectedValue,
                    onChanged: (kst) => _setRadioValue(kst),
                    value: KingdomSortType.values[index],
                    groupValue: _selectedValue,
                  );
                },
              )
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                FlatButton(
                  child: const Text("Cancel"),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                FlatButton(
                  child: const Text("OK"),
                  onPressed: () { Navigator.of(context).pop(_selectedValue); },
                )
              ],
            )
          ]
        ),
      ),
    );
  }
}

class KingdomSortDialog extends StatefulWidget {
  final KingdomSortType _kst;
  KingdomSortDialog(this._kst);

  @override
  _KingdomSortDialogState createState() => _KingdomSortDialogState(this._kst);
}