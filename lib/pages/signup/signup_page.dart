import 'package:flutter/material.dart';
import 'package:pig_counter/constants/color.dart';

import '../../utils/app_bar.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appTopBar("注册"),
        body: Container(
          color: ColorConstants.backgroundColor,
          alignment: .center,
          child: Text("SignupPage"),
        ),
      ),
    );
  }
}
