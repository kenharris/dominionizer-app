import 'dart:convert';
import 'dart:math';

void deduplicateCardList(List<DominionCard> input) {
  int currentIndex = 0;
  int listEnd = input.length;
  while (currentIndex < listEnd) {
    input.removeWhere((dc) => dc.id == input[currentIndex].id && dc.setName.toUpperCase() != input[currentIndex].setName.toUpperCase());
    currentIndex++;
    listEnd = input.length;
  }
}

void shuffleCardList(List<DominionCard> input) {
  Random r = Random();
  DominionCard tmp;
  for (int i=0; i<input.length; i++) {
    int rndIndex = r.nextInt(input.length - 1);
    tmp = input[i];
    input[i] = input[rndIndex];
    input[rndIndex] = tmp;
  }
}

class DominionCard {
  int id;
  String name;
  String setName;
  int coins;
  int potions;
  int debt;
  String topText;
  String bottomText;
  bool inSupply;
  bool isCompositePile;
  bool bringsCards;
  
  int get totalCost => coins ?? 0 + potions ?? 0 + debt ?? 0;

  String toJson() {
    Map<String, dynamic> _map = {
      'id' : id,
      'name' : name,
      'set_name' : setName,
      'coins' : coins,
      'potions' : potions,
      'debt' : debt,
      'top_text' : topText,
      'bottom_text' : bottomText,
      'in_supply': inSupply ? 1 : 0,
      'is_composite_pile': isCompositePile ? 1 : 0,
      'brings_cards': bringsCards ? 1 : 0
    };
    return jsonEncode(_map);
  }

  DominionCard.fromMap(Map<String, dynamic> map)
    : id = map['id'],
      name = map['name'],
      setName = map['set_name'],
      coins = map['coins'] ?? 0,
      potions = map['potions'] ?? 0,
      debt = map['debt'] ?? 0,
      topText = map['top_text'] ?? "",
      bottomText = map['bottom_text'] ?? "",
      inSupply = map['in_supply'] == 1 ? true : false,
      isCompositePile = map['is_composite_pile'] == 1 ? true : false,
      bringsCards = map['brings_cards'] == 1 ? true : false;
}