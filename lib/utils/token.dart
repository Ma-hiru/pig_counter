import 'package:pig_counter/constants/http.dart';
import 'package:pig_counter/utils/local.dart';

class _TokenManager {
  String? _token;
  static const String _tokenStoreKey = "auth_token";

  _TokenManager() {
    _token = LocalStore.getItem(_TokenManager._tokenStoreKey).maybeString;
  }

  Future setToken(String token) async {
    _token = token;
    await LocalStore.setItem(_TokenManager._tokenStoreKey, token);
  }

  String? getToken() {
    if (_token is String && _token!.isNotEmpty) {
      return HTTPConstants.tokenPrefix + _token!;
    } else {
      return null;
    }
  }

  Future removeToken() async {
    _token = null;
    await LocalStore.removeItem(_TokenManager._tokenStoreKey);
  }
}

final tokenManager = _TokenManager();
