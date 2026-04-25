import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pig_counter/pages/history/history_page.dart';
import 'package:pig_counter/pages/dead_pig/dead_pig_page.dart';
import 'package:pig_counter/pages/preview/preview_page.dart';
import 'package:pig_counter/pages/profile/profile_page.dart';
import 'package:pig_counter/pages/stats/stats_page.dart';
import 'package:pig_counter/pages/upload/upload_page.dart';

import '../constants/routes.dart';
import '../pages/home/home_page.dart';
import '../pages/login/login_page.dart';
import '../pages/settings/settings_page.dart';
import '../pages/signup/signup_page.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

Widget getRootWidget() {
  return OKToast(
    child: MaterialApp(
      navigatorKey: rootNavigatorKey,
      initialRoute: "/",
      routes: {
        RoutesPathConstants.home: (_) => const HomePage(),
        RoutesPathConstants.login: (_) => const LoginPage(),
        RoutesPathConstants.signup: (_) => const SignupPage(),
        RoutesPathConstants.profile: (_) => const ProfilePage(),
        RoutesPathConstants.settings: (_) => const SettingsPage(),
        RoutesPathConstants.upload: (_) => const UploadPage(),
        RoutesPathConstants.deadPig: (_) => const DeadPigPage(),
        RoutesPathConstants.history: (_) => const HistoryPage(),
        RoutesPathConstants.stats: (_) => const StatsPage(),
        RoutesPathConstants.preview: (_) => const PreviewPage(),
      },
    ),
  );
}
