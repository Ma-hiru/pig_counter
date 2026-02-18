import 'package:pig_counter/constants/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _TokenManager {
  String? _token;

  Future init() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(HTTPConstants.tokenKey);
  }

  Future setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(HTTPConstants.tokenKey, token);
    _token = token;
  }

  String? getToken() {
    if (_token is String && _token!.isNotEmpty) {
      return "Bearer $_token";
    } else {
      return null;
    }
  }

  Future removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(HTTPConstants.tokenKey);
    _token = null;
  }
}

final tokenManager = _TokenManager();
