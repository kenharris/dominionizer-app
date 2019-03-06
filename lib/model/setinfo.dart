import 'package:flutter/material.dart';

class SetInfo {
  SetInfo({Key key, this.id, this.name, this.selected});

  String name;
  int id;
  bool selected;

  SetInfo.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      name = json['name'],
      selected = json['selected'];
  
  Map<String, dynamic> toJson() =>
    {
      'id': id,
      'name': name,
      'selected':selected
    };
}