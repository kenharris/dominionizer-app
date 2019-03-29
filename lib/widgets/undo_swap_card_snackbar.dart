import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

@immutable
class UndoSwapCardSnackbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text("Card exchange undone.",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).accentColor)),
    ]);
  }
}
