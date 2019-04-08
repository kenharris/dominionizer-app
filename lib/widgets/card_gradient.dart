import 'package:dominionizer_app/model/dominion_card.dart';
import 'package:flutter/material.dart';

class CardGradient {
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

  static LinearGradient createLinearGradient(DominionCard card) {
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
      // begin: Alignment.topCenter,
      // end: Alignment.bottomCenter,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: colors,
    );
  }

  static RadialGradient createRadialGradient(DominionCard card) {
    int alpha = 150;
    var colors = <Color>[];

    if (card.types.any((t) => t.toUpperCase() == "VICTORY")) {
      colors.add(Colors.green.withAlpha(alpha));
    }

    if (card.types.any((t) => t.toUpperCase() == "DURATION")) {
      colors.add(Colors.orange.withAlpha(alpha));
    }

    if (card.types.any((t) => t.toUpperCase() == "TREASURE")) {
      colors.add(Colors.yellow.withAlpha(alpha));
    }

    if (card.types.any((t) => t.toUpperCase() == "ACTION")) {
      colors.add(Colors.grey.withAlpha(alpha));
    }

    double evenSpacing = 1 / colors.length;
    double currentSpacing = 0;
    var stops = <double>[];
    for (var i = 0; i < colors.length; i++) {
      stops.add(currentSpacing);
      currentSpacing += evenSpacing;
    }

    if (stops.length == 0) {
      stops.add(1);
    }

    if (colors.length == 0) {
      colors.add(Colors.grey);
    }

    return RadialGradient(
      colors: colors,
      radius: 2,
      stops: stops
    );
  }
}