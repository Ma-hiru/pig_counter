import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pig_counter/pages/history/history_page.dart';
import 'package:pig_counter/pages/preview/preview_page.dart';
import 'package:pig_counter/pages/profile/profile_page.dart';
import 'package:pig_counter/pages/stats/stats_page.dart';
import 'package:pig_counter/pages/upload/upload_page.dart';

import '../constants/routes.dart';
import '../pages/home/home_page.dart';
import '../pages/login/login_page.dart';
import '../pages/settings/settings_page.dart';
import '../pages/signup/signup_page.dart';

Widget getRootWidget() {
  return OKToast(
    child: MaterialApp(
      initialRoute: "/",
      routes: {
        RoutesPathConstants.home: (ctx) => const HomePage(),
        RoutesPathConstants.login: (ctx) => const LoginPage(),
        RoutesPathConstants.signup: (ctx) => const SignupPage(),
        RoutesPathConstants.profile: (ctx) => const ProfilePage(),
        RoutesPathConstants.settings: (ctx) => const SettingsPage(),
        RoutesPathConstants.upload: (ctx) => const UploadPage(),
        RoutesPathConstants.history: (ctx) => const HistoryPage(),
        RoutesPathConstants.stats: (ctx) => const StatsPage(),
        RoutesPathConstants.preview: (ctx) => const PreviewPage(),
      },
    ),
  );
}
