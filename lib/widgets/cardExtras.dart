import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

@immutable
class CardExtras extends StatelessWidget {
  final bool bringsCards, isCompositePile;
  final double iconSize;

  CardExtras({ this.bringsCards, this.isCompositePile, this.iconSize });

  @override
  Widget build(BuildContext context) {
    List<Widget> builder = List<Widget>();

    if (bringsCards ?? false) {
      builder.add(Icon(Icons.more, size: this.iconSize ?? 14));
    }

    if (isCompositePile ?? false) {
      builder.add(Icon(Icons.queue, size: this.iconSize ?? 14));
    }

    if (builder.length == 0) {
      builder.add(Text(""));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: builder.toList(),
    );
  }
}