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
  List<String> types;
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
      'types' : jsonEncode(types),
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

  DominionCard.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      name = json['name'],
      setName = json['set_name'],
      types = json['types'] == null ? [] : (jsonDecode(json['types']) as List<dynamic>).cast<String>(),
      coins = json['coins'] ?? 0,
      potions = json['potions'] ?? 0,
      debt = json['debt'] ?? 0,
      topText = json['top_text'] ?? "",
      bottomText = json['bottom_text'] ?? "",
      inSupply = json['in_supply'] == 1 ? true : false,
      isCompositePile = json['is_composite_pile'] == 1 ? true : false,
      bringsCards = json['brings_cards'] == 1 ? true : false;

  DominionCard.fromMap(Map<String, dynamic> map)
    : id = map['id'],
      name = map['name'],
      setName = map['set_name'],
      types = (map['type_names'] ?? "").toString().split(","),
      coins = map['coins'] ?? 0,
      potions = map['potions'] ?? 0,
      debt = map['debt'] ?? 0,
      topText = map['top_text'] ?? "",
      bottomText = map['bottom_text'] ?? "",
      inSupply = map['in_supply'] == 1 ? true : false,
      isCompositePile = map['is_composite_pile'] == 1 ? true : false,
      bringsCards = map['brings_cards'] == 1 ? true : false;
}