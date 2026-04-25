import 'package:pig_counter/utils/persistence.dart';

class UserAuthSession {
  final String token;
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final int expiresIn;
  final int refreshExpiresIn;

  const UserAuthSession({
    required this.token,
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.expiresIn,
    required this.refreshExpiresIn,
  });

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static String _toStringSafe(dynamic value) {
    if (value == null) return "";
    return value.toString();
  }

  factory UserAuthSession.fromJSON(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw FormatException("Invalid JSON format for UserAuthSession");
    }
    final legacyToken = _toStringSafe(json["token"]);
    final accessToken = _toStringSafe(json["accessToken"]);
    final normalizedAccessToken = accessToken.isNotEmpty
        ? accessToken
        : legacyToken;
    return UserAuthSession(
      token: normalizedAccessToken,
      accessToken: normalizedAccessToken,
      refreshToken: _toStringSafe(json["refreshToken"]),
      tokenType: _toStringSafe(json["tokenType"]).isNotEmpty
          ? _toStringSafe(json["tokenType"])
          : "Bearer",
      expiresIn: _toInt(json["expiresIn"]),
      refreshExpiresIn: _toInt(json["refreshExpiresIn"]),
    );
  }

  factory UserAuthSession.empty() {
    return const UserAuthSession(
      token: "",
      accessToken: "",
      refreshToken: "",
      tokenType: "Bearer",
      expiresIn: 0,
      refreshExpiresIn: 0,
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "token": token,
      "accessToken": accessToken,
      "refreshToken": refreshToken,
      "tokenType": tokenType,
      "expiresIn": expiresIn,
      "refreshExpiresIn": refreshExpiresIn,
    };
  }
}

class UserProfile implements Persistable<UserProfile> {
  final int id;
  final int orgId;
  final String username;
  final String name;
  final String profilePicture;
  final String token;
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final int expiresIn;
  final int refreshExpiresIn;
  final String organization;
  final bool admin;

  const UserProfile({
    required this.id,
    required this.orgId,
    required this.username,
    required this.name,
    required this.profilePicture,
    required this.token,
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.expiresIn,
    required this.refreshExpiresIn,
    required this.organization,
    required this.admin,
  });

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static String _toStringSafe(dynamic value) {
    if (value == null) return "";
    return value.toString();
  }

  static bool _toBool(dynamic value) {
    if (value is bool) return value;
    if (value is int) return value != 0;
    if (value is String) {
      final lower = value.toLowerCase();
      return lower == "true" || lower == "1";
    }
    return false;
  }

  factory UserProfile.fromJSON(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw FormatException("Invalid JSON format for UserProfile");
    }
    final auth = UserAuthSession.fromJSON(json);
    return UserProfile(
      id: _toInt(json["id"]),
      orgId: _toInt(json["orgId"]),
      username: _toStringSafe(json["username"]),
      name: _toStringSafe(json["name"]),
      profilePicture: _toStringSafe(json["profilePicture"]),
      token: auth.token,
      accessToken: auth.accessToken,
      refreshToken: auth.refreshToken,
      tokenType: auth.tokenType,
      expiresIn: auth.expiresIn,
      refreshExpiresIn: auth.refreshExpiresIn,
      organization: _toStringSafe(json["organization"]),
      admin: _toBool(json["admin"]),
    );
  }

  factory UserProfile.empty() {
    return const UserProfile(
      id: 0,
      orgId: 0,
      username: "",
      name: "",
      profilePicture: "",
      token: "",
      accessToken: "",
      refreshToken: "",
      tokenType: "Bearer",
      expiresIn: 0,
      refreshExpiresIn: 0,
      organization: "",
      admin: false,
    );
  }

  factory UserProfile.test({int avatarSize = 640}) {
    return UserProfile(
      id: 1,
      orgId: 1,
      username: "testuser",
      name: "测试用户",
      profilePicture:
          "https://thirdqq.qlogo.cn/g?b=qq&nk=1759961798&s=${avatarSize.toString()}",
      token: "test-token",
      accessToken: "test-token",
      refreshToken: "test-refresh-token",
      tokenType: "Bearer",
      expiresIn: 7200,
      refreshExpiresIn: 604800,
      organization: "测试组织",
      admin: false,
    );
  }

  UserProfile copyWith({
    int? id,
    int? orgId,
    String? username,
    String? name,
    String? profilePicture,
    String? token,
    String? accessToken,
    String? refreshToken,
    String? tokenType,
    int? expiresIn,
    int? refreshExpiresIn,
    String? organization,
    bool? admin,
  }) {
    final nextAccessToken = accessToken ?? token ?? this.accessToken;
    return UserProfile(
      id: id ?? this.id,
      orgId: orgId ?? this.orgId,
      username: username ?? this.username,
      name: name ?? this.name,
      profilePicture: profilePicture ?? this.profilePicture,
      token: nextAccessToken,
      accessToken: nextAccessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      tokenType: tokenType ?? this.tokenType,
      expiresIn: expiresIn ?? this.expiresIn,
      refreshExpiresIn: refreshExpiresIn ?? this.refreshExpiresIn,
      organization: organization ?? this.organization,
      admin: admin ?? this.admin,
    );
  }

  UserProfile copyWithAuth(UserAuthSession auth) {
    return copyWith(
      token: auth.accessToken,
      accessToken: auth.accessToken,
      refreshToken: auth.refreshToken,
      tokenType: auth.tokenType,
      expiresIn: auth.expiresIn,
      refreshExpiresIn: auth.refreshExpiresIn,
    );
  }

  @override
  UserProfile fromJSON(json) => UserProfile.fromJSON(json);

  @override
  Map<String, dynamic> toJSON() {
    return {
      "id": id,
      "orgId": orgId,
      "username": username,
      "name": name,
      "profilePicture": profilePicture,
      "token": token,
      "accessToken": accessToken,
      "refreshToken": refreshToken,
      "tokenType": tokenType,
      "expiresIn": expiresIn,
      "refreshExpiresIn": refreshExpiresIn,
      "organization": organization,
      "admin": admin,
    };
  }
}
