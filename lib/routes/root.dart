import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

import '../pages/home/home_page.dart';
import '../pages/login/login_page.dart';
import '../pages/settings/settings_page.dart';
import '../pages/signup/signup_page.dart';

Widget getRootWidget() {
  return OKToast(
    child: MaterialApp(
      initialRoute: "/",
      routes: {
        "/": (ctx) => const HomePage(),
        "/login": (ctx) => const LoginPage(),
        "/signup": (ctx) => const SignupPage(),
        "/settings": (ctx) => const SettingsPage(),
      },
    ),
  );
}
