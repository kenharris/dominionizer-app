import 'dart:convert';

import 'package:meta/meta.dart';

@immutable
class CategoryValue {
  final int id;
  final bool included;

  CategoryValue(this.id, this.included);

  String toJson() {
    Map<String, dynamic> _map = {
      'id' : id,
      'included' : included
    };
    return jsonEncode(_map);
  }

  CategoryValue.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      included = json['included'];
}

@immutable
class CardCategory {
  final int id;
  final String name;
  final String description;
  final int count;

  CardCategory(this.id, this.name, this.description, this.count);

  CardCategory.fromMap(Map<String, dynamic> map) :
    id = map['id'],
    name = map['name'],
    description = map['description'],
    count = map['count'];
}

@immutable
class RulesState {
  final List<CardCategory> categories;
  final List<CategoryValue> categoryValues;

  RulesState(this.categories, this.categoryValues);

  bool getCategoryValue(int categoryId) {
    if (categoryValues == null || categoryValues.length == 0)
      return false;

    if (categoryValues.any((cv) => cv.id == categoryId)) {
      return categoryValues.where((cv) => cv.id == categoryId).first.included;
    } else {
      return false;
    }
  }
}