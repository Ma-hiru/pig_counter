import 'package:pig_counter/constants/http.dart';
import 'package:pig_counter/utils/local.dart';

class TokenManager {
  static const String _tokenStoreKey = "auth_token";
  static String? _token;

  static void init() {
    _token = LocalStore.getItem(TokenManager._tokenStoreKey).maybeString;
  }

  static Future<bool> setToken(String token) {
    _token = token;
    return LocalStore.setItem(TokenManager._tokenStoreKey, token);
  }

  static String? getToken() {
    if (_token is String && _token!.isNotEmpty) {
      return HTTPConstants.tokenPrefix + _token!;
    } else {
      return null;
    }
  }

  static Future<bool> removeToken() {
    _token = null;
    return LocalStore.removeItem(TokenManager._tokenStoreKey);
  }
}
