import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pig_counter/routes/root.dart';
import 'package:pig_counter/stores/init.dart';
import 'package:pig_counter/utils/local.dart';
import 'package:video_player_media_kit/video_player_media_kit.dart';

void main() {
  init().then((_) {
    runApp(getRootWidget());
  });
}

Future init() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux) {
    VideoPlayerMediaKit.ensureInitialized(linux: true, windows: true);
  }
  await LocalStore.init();
  initGetXStore();
}
