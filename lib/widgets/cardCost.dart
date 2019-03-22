import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

@immutable
class CardCost extends StatelessWidget {
  final int coins, potions, debt;
  final double fontSize, iconSize, space;

  CardCost({@required this.coins, @required this.potions, @required this.debt, this.fontSize, this.iconSize, this.space});

  @override
  Widget build(BuildContext context) {
    List<Widget> builder = List<Widget>();

    double size = this.fontSize ?? 14;
    double iconSize = this.iconSize ?? 8;
    double space = this.space ?? 4;
    TextStyle style = TextStyle(fontSize: size);

    if (coins > 0 || (potions == 0 && debt == 0)) {
      builder.add(Text("$coins", style: style));
      builder.add(Icon(FontAwesomeIcons.coins, size: iconSize, color: Colors.yellow,));
    }

    if (potions > 0) {
      if (coins > 0)
        builder.add(SizedBox(width: space));

      if (potions > 1) {
        builder.add(Text("$potions", style: style));
      }
      builder.add(Icon(FontAwesomeIcons.flask, size: iconSize, color: Colors.blue));
    }

    if (debt > 0) {
      if (coins > 0 || potions > 0)
        builder.add(SizedBox(width: space));

      builder.add(Text("$debt", style: style));
      builder.add(Icon(FontAwesomeIcons.drawPolygon, size: iconSize));
    }

    return Row(
      children: builder.toList(),
    );
  }
}