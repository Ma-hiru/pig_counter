import 'package:flutter/material.dart';

import '../pages/home/home_page.dart';
import '../pages/login/login_page.dart';
import '../pages/signup/signup_page.dart';

Widget getRootWidget() {
  return MaterialApp(
    initialRoute: "/",
    routes: {
      "/": (ctx) => const HomePage(),
      "/login": (ctx) => const LoginPage(),
      "/signup": (ctx) => const SignupPage(),
    },
  );
}
