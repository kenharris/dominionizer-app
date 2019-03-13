import 'dart:convert';

import 'package:dominionizer_app/model/setinfo.dart';

class Card {
  int id;
  String name;
  int cardSet;
  int coins;
  int potions;
  int debt;
  String topText;
  String bottomText;

  String get setName => SetNames[SetName.values[cardSet].index];
  int get totalCost => coins ?? 0 + potions ?? 0 + debt ?? 0;

  String toJson() {
    Map<String, dynamic> _map = {
      'id' : id,
      'name' : name,
      'set' : cardSet,
      'coins' : coins,
      'potions' : potions,
      'debt' : debt,
      'topText' : topText,
      'bottomText' :bottomText
    };
    return jsonEncode(_map);
  }

  Card.fromMap(Map<String, dynamic> map)
    : id = map['id'],
      name = map['name'],
      cardSet = map['set'],
      coins = map['coins'] ?? 0,
      potions = map['potions'] ?? 0,
      debt = map['debt'] ?? 0,
      topText = map['top_text'] ?? "",
      bottomText = map['bottom_text'] ?? "";
}