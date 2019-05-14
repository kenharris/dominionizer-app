import 'dart:convert';
import 'dart:math';

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
  List<String> types;
  List<String> sets;
  List<String> categories;
  int coins;
  int potions;
  int debt;
  String topText;
  String bottomText;
  bool inSupply;
  bool isCompositePile;
  bool bringsCards;
  
  int get totalCost => coins ?? 0 + potions ?? 0 + debt ?? 0;
  String get setName => (sets != null && sets.length > 0) ? sets[0] : "";

  String toJson() {
    Map<String, dynamic> _map = {
      'id' : id,
      'name' : name,
      'sets' : jsonEncode(sets),
      'types' : jsonEncode(types),
      'categories' : jsonEncode(categories),
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
      sets = json['sets'] == null ? [] : (jsonDecode(json['sets']) as List<dynamic>).cast<String>(),
      types = json['types'] == null ? [] : (jsonDecode(json['types']) as List<dynamic>).cast<String>(),
      categories = json['categories'] == null ? [] : (jsonDecode(json['categories']) as List<dynamic>).cast<String>(),
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
      sets = (map['set_names'] ?? "").toString().split(","),
      types = (map['type_names'] ?? "").toString().split(","),
      categories = map['category_names']?.toString()?.split(",") ?? List<String>(),
      coins = map['coins'] ?? 0,
      potions = map['potions'] ?? 0,
      debt = map['debt'] ?? 0,
      topText = map['top_text'] ?? "",
      bottomText = map['bottom_text'] ?? "",
      inSupply = map['in_supply'] == 1 ? true : false,
      isCompositePile = map['is_composite_pile'] == 1 ? true : false,
      bringsCards = map['brings_cards'] == 1 ? true : false;
}