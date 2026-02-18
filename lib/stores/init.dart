import 'package:pig_counter/stores/token.dart';

Future initStore() async {
  await tokenManager.init();
}
