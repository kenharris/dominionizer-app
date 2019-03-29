import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

@immutable
class SwapCardSnackbar extends StatelessWidget {
  final String initialCardName;
  final String swappedCardName;
  final Function undoFunc;

  SwapCardSnackbar({@required this.initialCardName, @required this.swappedCardName, @required this.undoFunc});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
            flex: 0,
            child: Text(initialCardName,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).accentColor,
                    decoration: TextDecoration.underline))),
        Expanded(
          child: Icon(
            FontAwesomeIcons.longArrowAltRight,
            size: 18,
            color: Theme.of(context).accentColor,
          ),
        ),
        Flexible(
          flex: 1,
          child: Text(swappedCardName,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).accentColor,
                  decoration: TextDecoration.underline)),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: GestureDetector(
            child: Icon(FontAwesomeIcons.undo,
                size: 12, color: Theme.of(context).accentColor),
            onTap: () {
              undoFunc();
            },
          ),
        )
      ]);
  }
}