import 'package:get/get.dart';
import 'package:pig_counter/stores/local.dart';
import 'package:pig_counter/stores/token.dart';

import '../models/api/user.dart';

class UserController extends GetxController {
  final profile = UserProfile.empty().obs;
  static const _memoPwdKey = "memo_pwd";
  static const _memoUserKey = "memo_user";

  void updateUserProfile(UserProfile newProfile) {
    profile.value = newProfile;
    if (newProfile.token.isNotEmpty) {
      tokenManager.setToken(newProfile.token);
    } else {
      tokenManager.removeToken();
    }
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
}
