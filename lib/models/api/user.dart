import 'package:pig_counter/utils/persistence.dart';

class UserProfile implements Persistable<UserProfile> {
  final int id;
  final int orgId;
  final String username;
  final String name;
  final String profilePicture;
  final String token;
  final String organization;
  final bool admin;

  const UserProfile({
    required this.id,
    required this.orgId,
    required this.username,
    required this.name,
    required this.profilePicture,
    required this.token,
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
    return UserProfile(
      id: _toInt(json["id"]),
      orgId: _toInt(json["orgId"]),
      username: _toStringSafe(json["username"]),
      name: _toStringSafe(json["name"]),
      profilePicture: _toStringSafe(json["profilePicture"]),
      token: _toStringSafe(json["token"]),
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
      organization: "测试组织",
      admin: false,
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
      "organization": organization,
      "admin": admin,
    };
  }
}
