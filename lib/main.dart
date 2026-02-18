import 'package:flutter/material.dart';
import 'package:pig_counter/routes/root.dart';
import 'package:pig_counter/stores/init.dart';

Future main() async {
  await initStore();
  runApp(getRootWidget());
}
