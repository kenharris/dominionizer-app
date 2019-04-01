import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

@immutable
class CardText extends StatelessWidget {
  final String top, bottom;
  final double fontSize;

  CardText({@required this.top, @required this.bottom, this.fontSize});

  @override
  Widget build(BuildContext context) {
    List<Widget> builder = List<Widget>();

    TextStyle style = TextStyle(fontSize: fontSize);

    builder.add(
      Text("${top.replaceAll("\\n", "\n\n")}", 
        style: style,
        textAlign: TextAlign.center
      ),
    );

    if (bottom.trim().isNotEmpty) {
      builder.add(
        Padding(
          padding: EdgeInsets.only(top: 10),
          child:Container(
            decoration: BoxDecoration(
              border: BorderDirectional(
                top: BorderSide(width: 1)
              )
            ),
            child: Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text("${bottom.replaceAll("\\n", "\n\n")}", style: style)
            )
          )
        )
      );
    }

    return Column(
      children: builder.toList(),
    );
  }
}