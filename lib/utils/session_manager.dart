import 'package:pig_counter/models/api/user.dart';
import 'package:pig_counter/stores/token.dart';

class SessionManager {
  static Future<void> Function()? onUnauthorized;
  static Future<void> Function(UserAuthSession auth)? onTokensRefreshed;
  static bool _handlingUnauthorized = false;

  static Future<void> handleUnauthorized() async {
    if (_handlingUnauthorized) return;
    _handlingUnauthorized = true;

    try {
      await TokenManager.removeTokens();
      await onUnauthorized?.call();
    } finally {
      _handlingUnauthorized = false;
    }
  }
}
