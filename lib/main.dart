import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pig_counter/constants/routes.dart';
import 'package:pig_counter/models/api/user.dart';
import 'package:pig_counter/routes/root.dart';
import 'package:pig_counter/stores/init.dart';
import 'package:pig_counter/stores/token.dart';
import 'package:pig_counter/stores/user.dart';
import 'package:pig_counter/utils/local.dart';
import 'package:pig_counter/utils/session_manager.dart';
import 'package:pig_counter/utils/toast.dart';
import 'package:video_player_media_kit/video_player_media_kit.dart';

void main() {
  init().then((_) {
    runApp(getRootWidget());
  });
}

Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux) {
    VideoPlayerMediaKit.ensureInitialized(linux: true, windows: true);
  }
  return LocalStore.init().then((_) {
    TokenManager.init();
    initGetXStore();
    SessionManager.onTokensRefreshed = (auth) async {
      if (Get.isRegistered<UserController>()) {
        final userController = Get.find<UserController>();
        userController.updateUserProfile(
          userController.profile.value.copyWithAuth(auth),
        );
      }
    };
    SessionManager.onUnauthorized = () async {
      if (Get.isRegistered<UserController>()) {
        Get.find<UserController>().updateUserProfile(UserProfile.empty());
      }
      Toast.showToast(.error("登录已过期，请重新登录"));
      rootNavigatorKey.currentState?.pushNamedAndRemoveUntil(
        RoutesPathConstants.login,
        (route) => false,
      );
    };
  });
}
