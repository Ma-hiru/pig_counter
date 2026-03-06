import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

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
        RoutesPathConstants.settings: (ctx) => const SettingsPage(),
      },
    ),
  );
}
