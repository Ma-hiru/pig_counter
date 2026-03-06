import 'package:flutter/material.dart';
import 'package:pig_counter/routes/root.dart';
import 'package:pig_counter/stores/init.dart';
import 'package:pig_counter/utils/local.dart';

void main() {
  init().then((value) => runApp(getRootWidget()));
}

Future init() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStore.init();
  await initGetXStore();
}
