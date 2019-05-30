import 'package:dominionizer_app/model/dominion_card.dart';
import 'package:flutter/material.dart';

enum CardSideDecorationSide {
  Left,
  Right
}

class CardSideDecoration extends StatelessWidget {
  static const String ACTION = "ACTION";
  static const String ATTACK = "ATTACK";
  static const String DURATION = "DURATION";
  static const String TREASURE = "TREASURE";
  static const String VICTORY = "VICTORY";
  static const String REACTION = "REACTION";
  static const String NIGHT = "NIGHT";
  static const String RESERVE = "RESERVE";
  static const String LANDMARK = "LANDMARK";
  static const String PROJECT = "PROJECT";

  static Color defaultColor = Colors.grey.shade400;

  static int alpha = 150;
  static Map<String, Color> typeColors = {
    ACTION: defaultColor,
    ATTACK: defaultColor,
    DURATION: Color(0xfff68e28),
    TREASURE: Color(0xfff9d01d),
    VICTORY: Color(0xff8fd16e),
    REACTION: Color(0xff5c97b9),
    NIGHT: Color(0xff515155),
    RESERVE: Color(0xffd0b970),
    LANDMARK: Color(0xff53ac6b),
    PROJECT: Color(0xffe7a498)
  };

  static var includeActionAttackTypes = [
    VICTORY,
    TREASURE,
    NIGHT
  ];

  static var actionAttackTypes = [
    ACTION,
    ATTACK
  ];

  final DominionCard card;
  final double padding;
  final double width;
  final CardSideDecorationSide side;

  CardSideDecoration({@required this.card, this.side = CardSideDecorationSide.Left, this.padding = 10, this.width = 10});

  LinearGradient _createLinearGradient() {
    var colors = <Color>[];
    var types = <String>[];

    types = card.types.map((t) => t.toUpperCase()).toList();
    if (types.length > 1 && !types.any((t) => includeActionAttackTypes.contains(t))) {
      types.removeWhere((t) => actionAttackTypes.contains(t));
    }

    colors = types.map((t) => typeColors[t.toUpperCase()] ?? null).where((t) => t != null).toList();
    if (colors.length > 2) {
      while (colors.length > 2) {
        colors.removeAt(0);
      }
    }

    double evenSpacing = 1 / colors.length;
    double currentSpacing = 0;
    var stops = <double>[];
    for (var i = 0; i < colors.length; i++) {
      stops.add(currentSpacing);
      currentSpacing += evenSpacing;
    }

    if (stops.length == 0) {
      stops.addAll([0.5, 1]);
    }

    if (colors.length == 0) {
      colors.addAll([defaultColor, defaultColor]);
    }

    if (colors.length == 1) {
      colors.add(colors[0]);
    }

    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: colors,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: (this.side == CardSideDecorationSide.Left) ? EdgeInsets.only(right: padding) : EdgeInsets.only(left: padding),
      child: Container(
        width: width,
        decoration: BoxDecoration(
          gradient: _createLinearGradient()
        ),
      )
    );
  }
}