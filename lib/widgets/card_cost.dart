import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dominionizer_app/widgets/hexagon_border.dart';

@immutable
class CardCost extends StatelessWidget {
  final int coins, potions, debt;
  final double fontSize, iconSize, space, width;
  final bool compositePile, broughtCard;

  CardCost({@required this.coins, @required this.potions, @required this.debt, this.width, this.compositePile = false, this.broughtCard = false, this.fontSize, this.iconSize, this.space});

  @override
  Widget build(BuildContext context) {
    List<Widget> builder = List<Widget>();

    double size = this.fontSize ?? 14;
    double iconSize = this.iconSize ?? 8;
    double space = this.space ?? 4;

    TextStyle lightStyle = TextStyle(fontSize: size, color: Colors.black);
    TextStyle darkStyle = TextStyle(fontSize: size, color: Colors.white);

    if (!compositePile && !broughtCard) {
      if (coins > 0 || (potions == 0 && debt == 0)) {
        builder.add(Container(
          decoration: BoxDecoration(
            color: Colors.yellow,
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.grey
            )
          ),
          child: Padding(
            padding: EdgeInsets.all(size / 6),
            child: Text("$coins", style: lightStyle),
          )
        ));
      }

      if (potions > 0) {
        if (coins > 0)
          builder.add(SizedBox(width: space));

        if (potions > 1) {
          builder.add(Text("$potions", style: lightStyle));
        }
        builder.add(Icon(FontAwesomeIcons.flask, size: iconSize, color: Colors.blue));
      }

      if (debt > 0) {
        if (coins > 0 || potions > 0)
          builder.add(SizedBox(width: space));

        builder.add(
          Container(
            decoration: ShapeDecoration(
              shape: HexagonBorder(),
              color: Colors.brown,
            ),
            child: Padding(
              // padding: const EdgeInsets.fromLTRB(4.0, 2.0, 4.0, 2.0),
              padding: EdgeInsets.fromLTRB(size / 4, size / 6, size / 4, size / 6),
              child: Text("$debt", style: darkStyle),
            ),
          )
        );
      }
    } else {
      builder.add(Text(""));
    }

    if (width != null) {
      return Container(
        width: width,
        child: Row(
          children: builder.toList(),
        )
      );
    }
    
    return Row(
      children: builder.toList(),
    );
  }
}