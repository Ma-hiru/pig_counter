import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:pig_counter/routes/root.dart';
import 'package:pig_counter/stores/init.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initStore();
  try {
    await FlutterDisplayMode.setHighRefreshRate();
  } catch (_) {
    if (kDebugMode) {
      print("Failed to set high refresh rate");
    }
  }
  runApp(getRootWidget());
}
