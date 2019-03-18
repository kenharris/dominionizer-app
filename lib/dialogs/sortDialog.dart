import 'package:flutter/material.dart';

class _SortDialogState extends State<SortDialog> {
  int _selectedValue;

  _SortDialogState(this._selectedValue);

  void _setRadioValue(int sortValue) {
    setState((){
      _selectedValue = sortValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: widget._height,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: 
                ListView.builder(
                  itemCount: widget._strings.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return RadioListTile(
                      title: Text("${widget._strings[index]}"),
                      selected: index == _selectedValue,
                      onChanged: (sortValue) => _setRadioValue(sortValue),
                      value: index,
                      groupValue: _selectedValue,
                      activeColor: Theme.of(context).accentColor,
                    );
                  },
                )
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                    child: const Text("Cancel"),
                    textColor: Theme.of(context).accentColor,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  FlatButton(
                    child: const Text("OK"),
                    textColor: Theme.of(context).accentColor,
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

class SortDialog extends StatefulWidget {
  final int _value;
  final List<String> _strings;
  final double _height;

  SortDialog(this._value, this._strings, this._height);

  @override
  _SortDialogState createState() => _SortDialogState(_value);
}