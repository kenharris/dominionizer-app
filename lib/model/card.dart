import 'package:dominionizer_app/model/setinfo.dart';

class Card {
  String name;
  int cardSet;
  int coins;
  int potions;
  int debt;
  String topText;
  String bottomText;

  String get setName => SetNames[SetName.values[cardSet].index];
  int get totalCost => coins ?? 0 + potions ?? 0 + debt ?? 0;

  Card.fromMap(Map<String, dynamic> map)
    : name = map['name'],
      cardSet = map['set'],
      coins = map['coins'] ?? 0,
      potions = map['potions'] ?? 0,
      debt = map['debt'] ?? 0,
      topText = map['top_text'] ?? "",
      bottomText = map['bottom_text'] ?? "";
}