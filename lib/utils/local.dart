import 'package:flutter/foundation.dart';
import 'package:pig_counter/constants/err.dart';
import 'package:pig_counter/utils/as.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStore {
  static late SharedPreferences? _instance;

  static SharedPreferences get _prefs {
    if (_instance != null) return _instance!;
    throw ErrConstants.localStoreNotInit;
  }

  static Future init() async {
    _instance = await SharedPreferences.getInstance();
  }

  static AS getItem(String key) {
    if (kDebugMode) {
      print("SharedPreferences getItem $key: ${_prefs.get(key)}");
    }
    return AS(_prefs.get(key));
  }

  static Future<bool> setItem(String key, dynamic value) {
    if (kDebugMode) {
      print("SharedPreferences setItem $key: $value");
    }
    if (value == null) return removeItem(key);
    if (value is int) {
      return _prefs.setInt(key, value);
    } else if (value is double) {
      return _prefs.setDouble(key, value);
    } else if (value is String) {
      return _prefs.setString(key, value);
    } else if (value is bool) {
      return _prefs.setBool(key, value);
    } else if (value is List<String>) {
      return _prefs.setStringList(key, value);
    } else {
      if (kDebugMode) {
        print("SharedPreferences not support type ${value.runtimeType}");
      }
      return Future.value(false);
    }
  }

  static Future<bool> removeItem(String key) {
    return _prefs.remove(key);
  }
}
