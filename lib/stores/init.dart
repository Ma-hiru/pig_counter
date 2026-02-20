import 'package:get/get.dart';
import 'package:pig_counter/stores/token.dart';
import 'package:pig_counter/stores/user.dart';

Future initStore() async {
  Get.put(UserController(), permanent: true);
  await tokenManager.init();
}
