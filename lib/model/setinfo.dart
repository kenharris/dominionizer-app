import 'package:flutter/material.dart';

enum SetName {
  Undefined,
  Dominion,
  DominionSecondEdition,
	Intrigue,
  IntrigueSecondEdition,
	Seaside,
	Alchemy,
	Prosperity,
	Cornucopia,
	Hinterlands,
	DarkAges,
	Guilds,
	Adventures,
	Empires,
	Nocturne,
	Renaissance,
}

const SetNames = [
  "Undefined",
  "Dominion",
  "Dominion (2nd Edition)",
	"Intrigue",
  "Intrigue (2nd Edition)",
	"Seaside",
	"Alchemy",
	"Prosperity",
	"Cornucopia",
	"Hinterlands",
	"DarkAges",
	"Guilds",
	"Adventures",
	"Empires",
	"Nocturne",
	"Renaissance",
];

class SetInfo {
  SetInfo({Key key, this.id, this.name, this.released, this.included});

  String name;
  String released;
  SetName id;
  bool included;

  String get setName => SetNames[id.index];

  SetInfo.fromMap(Map<String, dynamic> map)
    : id = SetName.values[map['id']],
      name = map['name'],
      released = map['released'],
      included = map['included'] == 1;
  
  Map<String, dynamic> toMap() =>
    {
      'id': id.index,
      'name': name,
      'released':released,
      'included':included
    };

  SetInfo.fromJson(Map<String, dynamic> json)
    : id = SetName.values[json['id']],
      name = json['name'],
      released = json['released'],
      included = json['included'];
  
  Map<String, dynamic> toJson() =>
    {
      'id': id.index,
      'name': name,
      'released':released,
      'included':included
    };
}