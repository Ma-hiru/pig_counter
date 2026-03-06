import 'package:pig_counter/utils/persistence.dart';

class UserProfile implements Persistable<UserProfile> {
  final String id;
  final String username;
  final String name;
  final String profilePicture;
  final String token;
  final String organization;
  final bool admin;

  const UserProfile({
    required this.id,
    required this.username,
    required this.name,
    required this.profilePicture,
    required this.token,
    required this.organization,
    required this.admin,
  });

  factory UserProfile.fromJSON(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw FormatException("Invalid JSON format for UserProfile");
    }
    return UserProfile(
      id: json["id"] ?? "",
      username: json["username"] ?? "",
      name: json["name"] ?? "",
      profilePicture: json["profilePicture"] ?? "",
      token: json["token"] ?? "",
      organization: json["organization"] ?? "",
      admin: json["admin"] ?? false,
    );
  }

  factory UserProfile.empty() {
    return const UserProfile(
      id: "",
      username: "",
      name: "",
      profilePicture: "",
      token: "",
      organization: "",
      admin: false,
    );
  }

  @override
  UserProfile fromJSON(json) => UserProfile.fromJSON(json);

  @override
  Map<String, dynamic> toJSON() {
    return {
      "id": id,
      "username": username,
      "name": name,
      "profilePicture": profilePicture,
      "token": token,
      "organization": organization,
      "admin": admin,
    };
  }
}
