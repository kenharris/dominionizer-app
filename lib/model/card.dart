class Card {
  String name;
  int cardSet;
  int coins;
  int potions;
  int debt;
  String topText;
  String bottomText;

  Card.fromMap(Map<String, dynamic> map)
    : name = map['name'],
      cardSet = map['set'],
      coins = map['coins'] ?? 0,
      potions = map['potions'] ?? 0,
      debt = map['debt'] ?? 0,
      topText = map['top_text'] ?? "",
      bottomText = map['bottom_text'] ?? "";
}