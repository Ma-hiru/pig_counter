import 'package:pig_counter/constants/http.dart';
import 'package:pig_counter/models/api/user.dart';
import 'package:pig_counter/utils/local.dart';

class TokenManager {
  static const String _accessTokenStoreKey = "auth_access_token";
  static const String _refreshTokenStoreKey = "auth_refresh_token";
  static const String _tokenTypeStoreKey = "auth_token_type";
  static String? _accessToken;
  static String? _refreshToken;
  static String? _tokenType;

  static void init() {
    _accessToken = LocalStore.getItem(_accessTokenStoreKey).maybeString;
    _refreshToken = LocalStore.getItem(_refreshTokenStoreKey).maybeString;
    _tokenType = LocalStore.getItem(_tokenTypeStoreKey).maybeString;
  }

  static Future<bool> setToken(String token) {
    return setTokens(accessToken: token);
  }

  static Future<bool> setTokens({
    required String accessToken,
    String refreshToken = "",
    String tokenType = "Bearer",
  }) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    _tokenType = tokenType;
    final results = await Future.wait([
      LocalStore.setItem(_accessTokenStoreKey, accessToken),
      refreshToken.isNotEmpty
          ? LocalStore.setItem(_refreshTokenStoreKey, refreshToken)
          : LocalStore.removeItem(_refreshTokenStoreKey),
      LocalStore.setItem(_tokenTypeStoreKey, tokenType),
    ]);
    return results.every((item) => item);
  }

  static Future<bool> setTokensFromProfile(UserProfile profile) {
    return setTokens(
      accessToken: profile.accessToken.isNotEmpty
          ? profile.accessToken
          : profile.token,
      refreshToken: profile.refreshToken,
      tokenType: profile.tokenType,
    );
  }

  static String? getToken() {
    final accessToken = _accessToken;
    if (accessToken is String && accessToken.isNotEmpty) {
      final tokenType = (_tokenType is String && _tokenType!.isNotEmpty)
          ? _tokenType!
          : "Bearer";
      final prefix = tokenType.isNotEmpty ? "$tokenType " : "";
      return prefix + HTTPConstants.tokenPrefix + accessToken;
    } else {
      return null;
    }
  }

  static String? getRefreshToken() {
    if (_refreshToken is String && _refreshToken!.isNotEmpty) {
      return _refreshToken;
    }
    return null;
  }

  static String getTokenType() {
    if (_tokenType is String && _tokenType!.isNotEmpty) {
      return _tokenType!;
    }
    return "Bearer";
  }

  static Future<bool> removeToken() {
    return removeTokens();
  }

  static Future<bool> removeTokens() async {
    _accessToken = null;
    _refreshToken = null;
    _tokenType = null;
    final results = await Future.wait([
      LocalStore.removeItem(_accessTokenStoreKey),
      LocalStore.removeItem(_refreshTokenStoreKey),
      LocalStore.removeItem(_tokenTypeStoreKey),
    ]);
    return results.every((item) => item);
  }
}
