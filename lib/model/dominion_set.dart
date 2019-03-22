import 'package:flutter/material.dart';

class DominionSet {
  DominionSet({Key key, this.id, this.name, this.released, this.included});

  String name;
  String released;
  int id;
  bool included;

  DominionSet.fromMap(Map<String, dynamic> map)
    : id = map['id'],
      name = map['name'],
      released = map['released'],
      included = map['included'] == 1;
  
  Map<String, dynamic> toMap() =>
    {
      'id': id,
      'name': name,
      'released':released,
      'included':included
    };

  DominionSet.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      name = json['name'],
      released = json['released'],
      included = json['included'];
  
  Map<String, dynamic> toJson() =>
    {
      'id': id,
      'name': name,
      'released':released,
      'included':included
    };
}