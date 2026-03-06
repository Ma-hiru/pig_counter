import 'dart:convert';

import 'package:pig_counter/utils/local.dart';

abstract class Persistable<T> {
  Map<String, dynamic> toJSON();

  T fromJSON(dynamic json);
}

class Persistence {
  static T Load<T extends Persistable>(T instance, String key) {
    final local = LocalStore.getItem(key).maybeString;
    return local is String ? instance.fromJSON(jsonDecode(local)) : instance;
  }

  static Future<bool> Save<T extends Persistable>(T instance, String key) {
    return LocalStore.setItem(key, jsonEncode(instance.toJSON()));
  }
}
