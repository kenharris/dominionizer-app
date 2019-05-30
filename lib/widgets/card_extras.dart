import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

@immutable
class CardExtras extends StatelessWidget {
  final bool bringsCards, isCompositePile;
  final double iconSize;
  final Color color;

  CardExtras({ this.bringsCards, this.isCompositePile, this.iconSize, @required this.color });

  @override
  Widget build(BuildContext context) {
    List<Widget> builder = List<Widget>();

    if (bringsCards ?? false) {
      builder.add(Icon(Icons.add_circle, size: this.iconSize ?? 14, color: color,));
    }

    if (isCompositePile ?? false) {
      builder.add(Icon(FontAwesomeIcons.layerGroup, size: this.iconSize ?? 14, color: color,));
    }

    if (builder.length == 0) {
      builder.add(Text(""));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: builder.toList(),
    );
  }
}