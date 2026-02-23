import 'package:flutter/material.dart';
import 'package:pig_counter/routes/root.dart';
import 'package:pig_counter/stores/init.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initStore();
  runApp(getRootWidget());
}
