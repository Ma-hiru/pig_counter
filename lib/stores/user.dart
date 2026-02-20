import 'package:get/get.dart';
import 'package:pig_counter/stores/token.dart';

import '../models/api/user.dart';

class UserController extends GetxController {
  final profile = UserProfile.empty().obs;

  void updateUserProfile(UserProfile newProfile) {
    profile.value = newProfile;
    if (newProfile.token.isNotEmpty) {
      tokenManager.setToken(newProfile.token);
    } else {
      tokenManager.removeToken();
    }
  }
}
