import 'package:get/get.dart';
import 'package:pig_counter/stores/local.dart';
import 'package:pig_counter/stores/user.dart';

Future initStore() async {
  await LocalStore.init();
  Get.put(UserController(), permanent: true);
}
