import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pig_counter/api/index.dart';
import 'package:pig_counter/stores/token.dart';
import 'package:pig_counter/utils/local.dart';
import 'package:pig_counter/utils/persistence.dart';

import '../constants/routes.dart';
import '../models/api/user.dart';
import '../utils/modal.dart';

class UserController extends GetxController {
  static const _userProfilePersistenceKey = "user_profile";
  static const _memoPwdKey = "memo_pwd";
  static const _memoUserKey = "memo_user";
  static UserProfile? _loadedInstance;

  UserProfile get persistenceLoadedProfile {
    return UserController._loadedInstance ??= Persistence.Load(
      UserProfile.empty(),
      _userProfilePersistenceKey,
    );
  }

  late final isLoggedIn = persistenceLoadedProfile.token.isNotEmpty.obs;
  late final profile = persistenceLoadedProfile.obs;

  void updateUserProfile(UserProfile newProfile) {
    UserController._loadedInstance = newProfile;
    profile.value = newProfile;
    final accessToken = newProfile.accessToken.isNotEmpty
        ? newProfile.accessToken
        : newProfile.token;
    if (accessToken.isNotEmpty) {
      TokenManager.setTokensFromProfile(newProfile);
      isLoggedIn.value = true;
    } else {
      TokenManager.removeTokens();
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
          API.User.logout();
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
