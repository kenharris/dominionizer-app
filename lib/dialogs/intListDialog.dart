import 'package:flutter/material.dart';

class _IntListDialogState extends State<IntListDialog> {
  final Sink<int> _sink;
  int _selectedValue;

  _IntListDialogState(this._sink, this._selectedValue);

  void _setRadioValue(int i) {
    setState((){
      _selectedValue = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.yellow,
      child: Container(
        height: 400,
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: widget._values.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return RadioListTile(
                    title: Text("${widget._values[index]}"),
                    subtitle: widget._values[index] == widget._defaultValue ? Text("Default") : null,
                    selected: widget._values[index] == _selectedValue,
                    onChanged: (i) => _setRadioValue(i),
                    value: widget._values[index],
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
                  onPressed: () { _sink.add(_selectedValue); Navigator.of(context).pop(); },
                )
              ],
            )
          ]
        ),
      ),
    );
  }
}

class IntListDialog extends StatefulWidget {
  List<int> _values;
  int _selectedValue;
  int _defaultValue;
  Sink<int> _sink;

  IntListDialog(this._values, this._selectedValue, this._defaultValue, this._sink);

  @override
  _IntListDialogState createState() => _IntListDialogState(this._sink, this._selectedValue);
}