import 'package:dominionizer_app/model/dominion_card.dart';
import 'package:flutter/material.dart';

class CardGradient {
  static LinearGradient createLinearGradient(DominionCard card) {
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

    double evenSpacing = .8 / colors.length;
    double currentSpacing = .1;
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

    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: colors,
      stops: stops
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

    double evenSpacing = .6 / colors.length;
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