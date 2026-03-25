import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pig_counter/utils/local.dart';
import 'package:pig_counter/utils/persistence.dart';
import 'package:pig_counter/utils/token.dart';

import '../constants/routes.dart';
import '../models/api/user.dart';
import '../utils/modal.dart';

class UserController extends GetxController {
  static const _userProfilePersistenceKey = "user_profile";
  static const _memoPwdKey = "memo_pwd";
  static const _memoUserKey = "memo_user";

  UserProfile get persistenceLoadedProfile {
    return Persistence.Load(UserProfile.empty(), _userProfilePersistenceKey);
  }

  late final isLoggedIn = persistenceLoadedProfile.token.isNotEmpty.obs;
  late final profile = persistenceLoadedProfile.obs;

  void updateUserProfile(UserProfile newProfile) {
    profile.value = newProfile;
    if (newProfile.token.isNotEmpty) {
      tokenManager.setToken(newProfile.token);
      isLoggedIn.value = true;
    } else {
      tokenManager.removeToken();
      isLoggedIn.value = false;
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

  void logout(BuildContext context) {
    AppModal.show(
      context,
      .normal(
        title: "退出登录",
        description: "确定要退出当前账号吗？",
        confirmText: "退出",
        cancelText: "取消",
        onConfirm: () {
          updateUserProfile(.empty());
          Navigator.pushNamed(context, RoutesPathConstants.login);
        },
      ),
    );
  }

  String? getMemoUsername() {
    return LocalStore.getItem(UserController._memoUserKey).maybeString;
  }

  String? getMemoPassword() {
    return LocalStore.getItem(UserController._memoPwdKey).maybeString;
  }
}
