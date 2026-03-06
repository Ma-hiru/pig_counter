import 'package:get/get.dart';
import 'package:pig_counter/utils/local.dart';
import 'package:pig_counter/utils/persistence.dart';
import 'package:pig_counter/utils/token.dart';

import '../models/api/user.dart';

class UserController extends GetxController {
  static const _userProfilePersistenceKey = "user_profile";
  static const _memoPwdKey = "memo_pwd";
  static const _memoUserKey = "memo_user";

  final profile = Persistence.Load(
    UserProfile.empty(),
    _userProfilePersistenceKey,
  ).obs;

  void updateUserProfile(UserProfile newProfile) {
    profile.value = newProfile;
    if (newProfile.token.isNotEmpty) {
      tokenManager.setToken(newProfile.token);
    } else {
      tokenManager.removeToken();
    }
    Persistence.Save(newProfile, _userProfilePersistenceKey);
  }

  void memoUserAndPwd({String? username, String? password}) {
    LocalStore.setItem(UserController._memoUserKey, username);
    LocalStore.setItem(UserController._memoPwdKey, password);
  }

  void clearUserAndPwd({String? username, String? password}) {
    memoUserAndPwd(username: null, password: null);
  }

  String? getMemoUsername() {
    return LocalStore.getItem(UserController._memoUserKey).maybeString;
  }

  String? getMemoPassword() {
    return LocalStore.getItem(UserController._memoPwdKey).maybeString;
  }

  bool isLoggedIn() {
    return profile.value.token.isNotEmpty;
  }
}
