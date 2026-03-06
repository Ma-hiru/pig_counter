import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:pig_counter/constants/err.dart';

class AS {
  final dynamic value;
  bool _tryParse;

  AS(this.value, {bool tryParse = false}) : _tryParse = tryParse;

  AS get tryParse {
    _tryParse = true;
    return this;
  }

  int get asInt {
    try {
      return maybeInt as int;
    } catch (err) {
      if (kDebugMode) print('AS.asInt error: $err');
      throw ErrConstants.typeConvertError;
    }
  }

  int? get maybeInt {
    if (_tryParse) {
      if (value is int?) return value;
      if (value is double) return (value as double).toInt();
      if (value is String) {
        final res = int.tryParse(value);
        if (res != null) return res;
      }
      return null;
    }

    try {
      return value as int?;
    } catch (_) {
      return null;
    }
  }

  String get asString {
    try {
      return maybeString as String;
    } catch (err) {
      if (kDebugMode) print('AS.asString error: $err');
      throw ErrConstants.typeConvertError;
    }
  }

  String? get maybeString {
    if (_tryParse) {
      if (value is String?) return value;
      return value.toString();
    }
    try {
      return value as String?;
    } catch (_) {
      return null;
    }
  }

  bool get asBool {
    try {
      return maybeBool as bool;
    } catch (err) {
      if (kDebugMode) print('AS.asBool error: $err');
      throw ErrConstants.typeConvertError;
    }
  }

  bool? get maybeBool {
    if (_tryParse) {
      if (value is bool?) return value;
      if (value is String) {
        final lower = value.toLowerCase();
        if (lower == 'true') return true;
        if (lower == 'false') return false;
      }
      return null;
    }

    try {
      return value as bool?;
    } catch (_) {
      return null;
    }
  }

  double get asDouble {
    try {
      return maybeDouble as double;
    } catch (err) {
      if (kDebugMode) print('AS.asDouble error: $err');
      throw ErrConstants.typeConvertError;
    }
  }

  double? get maybeDouble {
    if (_tryParse) {
      if (value is double?) return value;
      if (value is int) return (value as int).toDouble();
      if (value is String) {
        final res = double.tryParse(value);
        if (res != null) return res;
      }
      return null;
    }

    try {
      return value as double?;
    } catch (_) {
      return null;
    }
  }
}
