import 'package:get/get.dart';
import 'package:pig_counter/stores/settings.dart';
import 'package:pig_counter/stores/user.dart';

void initGetXStore() {
  Get.put(UserController(), permanent: true);
  Get.put(SettingsController(), permanent: true);
}
