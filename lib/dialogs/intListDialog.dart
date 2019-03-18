import 'package:flutter/material.dart';

class _IntListDialogState extends State<IntListDialog> {
  int _selectedValue;

  _IntListDialogState(this._selectedValue);

  void _setRadioValue(int i) {
    setState((){
      _selectedValue = i;
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
                itemCount: widget._values.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return RadioListTile(
                    title: Text(
                      "${widget._values[index]}",
                      style: TextStyle(
                        color: (widget._values[index] == _selectedValue) ? Theme.of(context).primaryColor : Colors.grey
                      ),
                    ),
                    subtitle: widget._values[index] == widget._defaultValue 
                      ? Text(
                          "Default",
                          style: TextStyle(
                            color: (widget._values[index] == _selectedValue) ? Theme.of(context).primaryColor : Colors.grey
                          ),
                        ) : null,
                    selected: widget._values[index] == _selectedValue,
                    onChanged: (i) => _setRadioValue(i),
                    value: widget._values[index],
                    groupValue: _selectedValue,
                    activeColor: Theme.of(context).primaryColor
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

class IntListDialog extends StatefulWidget {
  List<int> _values;
  int _selectedValue;
  int _defaultValue;

  IntListDialog(this._values, this._selectedValue, this._defaultValue);

  @override
  _IntListDialogState createState() => _IntListDialogState(this._selectedValue);
}