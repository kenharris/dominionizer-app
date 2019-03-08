abstract class AppSettingValue { }

class AppSettingBooleanValue extends AppSettingValue {
  bool value;
  AppSettingBooleanValue(bool value) {
    this.value = value;
  }
}

class AppSettingIntegerValue extends AppSettingValue {
  int value;
  AppSettingIntegerValue(int value) {
    this.value = value;
  }
}

class AppSettingStringValue extends AppSettingValue {
  String value;
  AppSettingStringValue(String value) {
    this.value = value;
  }
}

enum AppSettingType {
  Bool,
  String,
  Int
}

class AppSetting {
  AppSetting({this.id, this.name, this.description, this.value});

  int id;
  String name;
  String description;
  AppSettingValue value;

  String get stringValue {
    if (value is AppSettingBooleanValue)
      return "${(value as AppSettingBooleanValue).value == true ? "Yes" : "No"}";

    if (value is AppSettingIntegerValue)
      return "${(value as AppSettingIntegerValue).value}";

    return (value as AppSettingStringValue).value;
  }

  static AppSettingType _mapValueToType(AppSettingValue value) {
    if (value is AppSettingBooleanValue)
      return AppSettingType.Bool;

    if (value is AppSettingIntegerValue)
      return AppSettingType.Int;

    return AppSettingType.String;
  }

  static String _mapValueToString(AppSettingValue value) {
    if (value is AppSettingBooleanValue) {
      return "${value.value == true ? 1 : 0}";
    }

    if (value is AppSettingIntegerValue) {
      return "${value.value}";
    }

    return (value as AppSettingStringValue).value;
  }

  static AppSettingValue _mapStringToValue(AppSettingType type, String value) {
    if (type == AppSettingType.Bool)
      return new AppSettingBooleanValue(int.parse(value) == 1 ? true : false);
    
    if (type == AppSettingType.Int)
      return new AppSettingIntegerValue(int.parse(value));

    return new AppSettingStringValue(value);    
  }

  AppSetting.fromMap(Map<String, dynamic> map)
    : id = map['id'],
      name = map['name'],
      description = map['description'],
      value = _mapStringToValue(AppSettingType.values[map['type']], map['value']);
  
  Map<String, dynamic> toMap() =>
    {
      'id': id,
      'name': name,
      'description': description,
      'value': _mapValueToString(value)
    };
}