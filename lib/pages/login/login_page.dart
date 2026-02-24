import 'package:flutter/material.dart';
import 'package:pig_counter/constants/ui.dart';
import 'package:pig_counter/widgets/button/button.dart';

import 'login_actions.dart';
import 'login_form.dart';
import 'login_logo.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Widget back() {
    return Expanded(
      child: Container(
        alignment: .bottomCenter,
        padding: .only(bottom: UIConstants.gapSize.xl),
        child: AppButton.text(
          label: "取消",
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "lib/assets/images/login_bg.jpg",
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: .start,
              children: [
                const LoginLogo(),
                const LoginForm(),
                const LoginActions(),
                back(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
